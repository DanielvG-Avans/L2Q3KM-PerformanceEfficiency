#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# SSR vs CSR energy benchmark for Samsung SM-A536B (Galaxy A53)
#
# Usage:
#   bash run.sh --ssr-url http://192.168.x.x:3000 \
#               --csr-url http://192.168.x.x:3001 \
#                   --runs 30
#
# What this does:
#   1. Generates a randomised interleaved run order (prevents thermal bias)
#   2. For each run: cools down, clears state, starts Perfetto, opens URL,
#      waits for load, pulls trace, saves DevTools metrics via CDP
#   3. After all runs: parses traces + produces statistical analysis
#
# =============================================================================

# ── Config ───────────────────────────────────────────────────────
RUNS=30
SSR_URL=""
CSR_URL=""
MAX_TEMP_C=37
COOL_WAIT_S=45
BATTERY_POLL_S=1
RUN_ID="$(date +%Y%m%d_%H%M%S)"
RUN_ROOT_DIR="../data/runs/${RUN_ID}"
RAW_DIR="${RUN_ROOT_DIR}/raw"
PROCESSED_DIR="${RUN_ROOT_DIR}/processed"
ANALYSIS_DIR="${RUN_ROOT_DIR}/analysis"
DEVICE_ID="${DEVICE_ID:-}"
BATTERY_POLL_PID=""

echo "=== SSR vs CSR Energy Benchmark ==="

# ── Args ─────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
  case $1 in
    --ssr-url) SSR_URL="$2"; shift 2 ;;
    --csr-url) CSR_URL="$2"; shift 2 ;;
    --runs)    RUNS="$2";    shift 2 ;;
    --device-id) DEVICE_ID="$2"; shift 2 ;;
    *) echo "Unknown argument: $1"; exit 1 ;;
  esac
done

[[ -z "$SSR_URL" || -z "$CSR_URL" ]] && {
  echo "ERROR: --ssr-url and --csr-url are required"
  exit 1
}

if [[ -z "$DEVICE_ID" ]]; then
  DEVICE_LINES=$(adb devices | awk 'NR>1 && $2=="device" {print $1}')
  DEVICE_COUNT=$(echo "$DEVICE_LINES" | sed '/^$/d' | wc -l | tr -d ' ')

  if [[ "$DEVICE_COUNT" -eq 1 ]]; then
    DEVICE_ID=$(echo "$DEVICE_LINES" | head -n 1)
  elif [[ "$DEVICE_COUNT" -eq 0 ]]; then
    echo "ERROR: no connected Android device found."
    echo "Tip: connect a device and run 'adb devices', or pass --device-id <serial>."
    exit 1
  else
    echo "ERROR: multiple devices connected; specify --device-id <serial>."
    echo "Connected devices:"
    echo "$DEVICE_LINES"
    exit 1
  fi
fi

echo "Using device: $DEVICE_ID"

mkdir -p "$RAW_DIR" "$PROCESSED_DIR" "$ANALYSIS_DIR"

start_battery_poller() {
  local out_csv="$1"

  echo "timestamp_s,current_ua,voltage_uv,temp_deci_c,charge_counter_uah,source" > "$out_csv"

  (
    while true; do
      local ts_s
      ts_s=$(python3 -c 'import time; print(f"{time.time():.3f}")')

      local dump
      dump=$(adb -s "$DEVICE_ID" shell dumpsys battery | tr -d '\r')

      local current_ua
      local voltage_mv
      local temp_deci_c
      local charge_counter_uah

      current_ua=$(echo "$dump" | awk -F': *' '/^  current now:/{print $2; exit}')
      voltage_mv=$(echo "$dump" | awk -F': *' '/^  voltage:/{print $2; exit}')
      temp_deci_c=$(echo "$dump" | awk -F': *' '/^  temperature:/{print $2; exit}')
      charge_counter_uah=$(echo "$dump" | awk -F': *' '/^  charge counter:/{print $2; exit}')

      # Samsung dumpsys current now often reports in mA; normalize to uA.
      if [[ "$current_ua" =~ ^-?[0-9]+$ ]] && (( current_ua > -20000 && current_ua < 20000 )); then
        current_ua=$((current_ua * 1000))
      fi

      if [[ "$voltage_mv" =~ ^[0-9-]+$ ]]; then
        voltage_uv=$((voltage_mv * 1000))
      else
        voltage_uv=""
      fi

      echo "$ts_s,${current_ua:-},${voltage_uv:-},${temp_deci_c:-},${charge_counter_uah:-},dumpsys_battery" >> "$out_csv"
      sleep "$BATTERY_POLL_S"
    done
  ) </dev/null &

  BATTERY_POLL_PID=$!
}

stop_battery_poller() {
  if [[ -n "${BATTERY_POLL_PID:-}" ]]; then
    kill "$BATTERY_POLL_PID" >/dev/null 2>&1 || true
    wait "$BATTERY_POLL_PID" 2>/dev/null || true
    BATTERY_POLL_PID=""
  fi
}

trap stop_battery_poller EXIT

# ── Chrome warmup (removes first-run bias) ───────────────────────
echo "→ Chrome warmup..."
adb -s "$DEVICE_ID" shell am start -a android.intent.action.VIEW -d "https://example.com" >/dev/null
sleep 10
adb -s "$DEVICE_ID" shell am force-stop com.android.chrome

# ── Ensure real battery telemetry (avoid frozen dumpsys state) ─────
adb -s "$DEVICE_ID" shell dumpsys battery reset >/dev/null 2>&1 || true

# ── Push Perfetto config ─────────────────────────────────────────
adb -s "$DEVICE_ID" shell mkdir -p /data/misc/perfetto-configs/
adb -s "$DEVICE_ID" push perfetto_config.pbtxt /data/misc/perfetto-configs/ >/dev/null

# ── CDP Forward ──────────────────────────────────────────────────
adb -s "$DEVICE_ID" forward tcp:9222 localabstract:chrome_devtools_remote

# ── Randomized run order ─────────────────────────────────────────
python3 - <<EOF > "$RAW_DIR/run_order.txt"
import random
runs = $RUNS
conds = ['ssr'] * runs + ['csr'] * runs
random.shuffle(conds)
print("\n".join(conds))
EOF

echo "run,condition,temp_c,timestamp" > "$RAW_DIR/temperatures.csv"

RUN_NUM=0

while IFS= read -r CONDITION <&3; do
  RUN_NUM=$((RUN_NUM + 1))
  URL=$([[ "$CONDITION" == "ssr" ]] && echo "$SSR_URL" || echo "$CSR_URL")

  TRACE_REMOTE="/data/misc/perfetto-traces/trace_${CONDITION}_${RUN_NUM}"
  TRACE_LOCAL="$RAW_DIR/run_${RUN_NUM}_${CONDITION}.perfetto-trace"
  METRICS_FILE="$RAW_DIR/run_${RUN_NUM}_${CONDITION}.json"
  BATTERY_CSV="$RAW_DIR/run_${RUN_NUM}_${CONDITION}.battery.csv"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Run $RUN_NUM ($CONDITION)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # ── 1. Cooldown + temperature check ────────────────────────────
  sleep "$COOL_WAIT_S"

  TEMP_RAW=$(adb -s "$DEVICE_ID" shell dumpsys battery | grep -m1 "temperature:" | awk '{print $2}' | tr -d '\r')

  if [[ -z "$TEMP_RAW" ]]; then
    TEMP_RAW=300
  fi

  TEMP_C=$(python3 -c "print(round($TEMP_RAW/10,1))")

  echo "$RUN_NUM,$CONDITION,$TEMP_C,$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$RAW_DIR/temperatures.csv"

  echo "Temp: ${TEMP_C}°C"

  if (( $(echo "$TEMP_C > $MAX_TEMP_C" | bc -l) )); then
    echo "Too hot, skipping run..."
    continue
  fi

  # ── 2. Reset state (correct method) ────────────────────────────
  adb -s "$DEVICE_ID" shell am force-stop com.android.chrome
  adb -s "$DEVICE_ID" shell pkill com.android.chrome 2>/dev/null || true
  adb -s "$DEVICE_ID" shell am kill-all >/dev/null 2>&1 || true
  adb -s "$DEVICE_ID" shell input keyevent KEYCODE_HOME
  sleep 2

  # Ensure brightness consistency
  adb -s "$DEVICE_ID" shell settings put system screen_brightness 120

  # ── 3. Start Perfetto trace ────────────────────────────────────
  adb -s "$DEVICE_ID" shell perfetto \
    --txt \
    --background \
    -c /data/misc/perfetto-configs/perfetto_config.pbtxt \
    -o "$TRACE_REMOTE"

  sleep 2

  # ── 3b. Start battery polling fallback capture ─────────────────
  start_battery_poller "$BATTERY_CSV"

  # ── 4. Run Puppeteer scenario ──────────────────────────────────
  adb -s "$DEVICE_ID" shell "echo 'chrome --remote-debugging-port=9222' > /data/local/tmp/chrome-command-line"
  adb -s "$DEVICE_ID" forward tcp:9222 localabstract:chrome_devtools_remote 2>/dev/null || true
  adb -s "$DEVICE_ID" shell am start -a android.intent.action.VIEW -d "$URL" >/dev/null 2>&1 || true
  sleep 2

  node scripts/puppeteer-scenario.js \
    --url "$URL" \
    --condition "$CONDITION" \
    --run "$RUN_NUM" \
    --device-id "$DEVICE_ID" \
    --out "$METRICS_FILE" \
    2>&1 | tee "$RAW_DIR/run_${RUN_NUM}_${CONDITION}.log"

  stop_battery_poller

  # ── 5. Stop trace ──────────────────────────────────────────────
  adb -s "$DEVICE_ID" shell pkill -SIGINT perfetto 2>/dev/null || true

  sleep 3

  # ── Pull trace (retry safe) ────────────────────────────────────
  adb -s "$DEVICE_ID" pull "$TRACE_REMOTE" "$TRACE_LOCAL" || {
    echo "Retrying pull..."
    sleep 2
    adb -s "$DEVICE_ID" pull "$TRACE_REMOTE" "$TRACE_LOCAL"
  }

  adb -s "$DEVICE_ID" shell rm -f "$TRACE_REMOTE" 2>/dev/null || true

  # ── 6. Sanity output ───────────────────────────────────────────
  if [[ -f "$METRICS_FILE" ]]; then
    LCP=$(python3 -c "import json; d=json.load(open('$METRICS_FILE')); pages=d.get('pages', []); print((pages[0].get('metrics', {}) if pages else {}).get('lcp', 'n/a'))" 2>/dev/null || echo "n/a")
    echo "LCP: ${LCP} ms"
  fi

  SIZE=$(wc -c < "$TRACE_LOCAL" 2>/dev/null || echo 0)
  echo "Trace size: $(echo "scale=1; $SIZE/1048576" | bc) MB"

done 3< "$RAW_DIR/run_order.txt"

adb -s "$DEVICE_ID" shell dumpsys battery reset >/dev/null 2>&1 || true

# ── Analysis ─────────────────────────────────────────────────────
echo ""
echo "Running analysis..."

python3 ../analysis/extract_energy.py --raw-dir "$RAW_DIR"
python3 ../analysis/analyze_runs.py   --raw-dir "$RAW_DIR"

# ── Publish outputs into run-scoped folders ──────────────────────
mkdir -p "$PROCESSED_DIR" "$ANALYSIS_DIR/plots"

[[ -f "$RAW_DIR/energy_metrics.csv" ]] && mv -f "$RAW_DIR/energy_metrics.csv" "$PROCESSED_DIR/energy_metrics.csv"
[[ -f "$RAW_DIR/statistics.csv" ]]    && mv -f "$RAW_DIR/statistics.csv" "$ANALYSIS_DIR/statistics.csv"
[[ -f "$RAW_DIR/report.md" ]]         && mv -f "$RAW_DIR/report.md" "$ANALYSIS_DIR/report.md"
if [[ -d "$RAW_DIR/plots" ]]; then
  rm -rf "$ANALYSIS_DIR/plots"
  mv "$RAW_DIR/plots" "$ANALYSIS_DIR/plots"
fi

echo ""
echo "Done → raw: $RAW_DIR"
echo "Done → processed: $PROCESSED_DIR"
echo "Done → analysis: $ANALYSIS_DIR"