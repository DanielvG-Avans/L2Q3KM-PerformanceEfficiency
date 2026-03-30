#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# SSR vs CSR energy benchmark for Samsung SM-A536B (Galaxy A53)
#
# Usage:
#   bash experiment.sh --ssr-url http://localhost:3000 \
#                      --csr-url http://localhost:3000 \
#                      --runs 30 \
#                      --scenarios static,dynamic,massive \
#                      --ssr-pages '/ssr?scenario={scenario}' \
#                      --csr-pages '/csr?scenario={scenario}'
#
# Prerequisites (one-time, on the phone):
#   1. chrome://flags/#enable-command-line-on-non-rooted-devices → Enabled
#   2. USB debugging enabled, device authorised
#   3. adb reverse already handled — this script sets it each run
# =============================================================================

# ── Config ───────────────────────────────────────────────────────
RUNS=30
SSR_URL=""
CSR_URL=""
SCENARIOS="static,dynamic,massive"
SSR_PAGES="/ssr?scenario={scenario}"
CSR_PAGES="/csr?scenario={scenario}"
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
    --ssr-url)    SSR_URL="$2";    shift 2 ;;
    --csr-url)    CSR_URL="$2";    shift 2 ;;
    --runs)       RUNS="$2";       shift 2 ;;
    --scenarios)  SCENARIOS="$2";  shift 2 ;;
    --ssr-pages)  SSR_PAGES="$2";  shift 2 ;;
    --csr-pages)  CSR_PAGES="$2";  shift 2 ;;
    --device-id)  DEVICE_ID="$2";  shift 2 ;;
    *) echo "Unknown argument: $1"; exit 1 ;;
  esac
done

[[ -z "$SSR_URL" || -z "$CSR_URL" ]] && {
  echo "ERROR: --ssr-url and --csr-url are required"
  exit 1
}

# ── Preflight checks ─────────────────────────────────────────────
[[ ! -f perfetto_config.pbtxt ]] && {
  echo "ERROR: perfetto_config.pbtxt not found in $(pwd)"
  exit 1
}

[[ ! -f scripts/puppeteer-scenario.js ]] && {
  echo "ERROR: scripts/puppeteer-scenario.js not found"
  exit 1
}

# ── Device detection ─────────────────────────────────────────────
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

# ── Battery poller ───────────────────────────────────────────────
start_battery_poller() {
  local out_csv="$1"
  echo "timestamp_s,current_ua,voltage_uv,temp_deci_c,charge_counter_uah,source" > "$out_csv"

  (
    while true; do
      local ts_s
      ts_s=$(python3 -c 'import time; print(f"{time.time():.3f}")')

      local dump
      dump=$(adb -s "$DEVICE_ID" shell dumpsys battery | tr -d '\r')

      local current_ua voltage_mv voltage_uv temp_deci_c charge_counter_uah

      current_ua=$(echo "$dump"       | awk -F': *' '/^  current now:/{print $2; exit}')
      voltage_mv=$(echo "$dump"       | awk -F': *' '/^  voltage:/{print $2; exit}')
      temp_deci_c=$(echo "$dump"      | awk -F': *' '/^  temperature:/{print $2; exit}')
      charge_counter_uah=$(echo "$dump" | awk -F': *' '/^  charge counter:/{print $2; exit}')

      # Samsung dumpsys often reports current in mA — normalise to uA
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
adb -s "$DEVICE_ID" shell am force-stop com.android.chrome
sleep 1

# Write Chrome command-line flags (requires chrome://flags/#enable-command-line-on-non-rooted-devices)
# Note: file must NOT contain "chrome" as first token — flags only
adb -s "$DEVICE_ID" shell "echo '--remote-debugging-port=9222' > /data/local/tmp/chrome-command-line"

adb -s "$DEVICE_ID" shell am start -a android.intent.action.VIEW -d "https://example.com" >/dev/null
sleep 10
adb -s "$DEVICE_ID" shell am force-stop com.android.chrome

# ── Reset battery stats ──────────────────────────────────────────
adb -s "$DEVICE_ID" shell dumpsys battery reset >/dev/null 2>&1 || true

# ── Push Perfetto config ─────────────────────────────────────────
adb -s "$DEVICE_ID" shell mkdir -p /data/misc/perfetto-configs/
adb -s "$DEVICE_ID" push perfetto_config.pbtxt /data/misc/perfetto-configs/ >/dev/null

# ── CDP forward (also re-set per run inside loop) ────────────────
adb -s "$DEVICE_ID" forward tcp:9222 localabstract:chrome_devtools_remote

# ── Randomised run order ─────────────────────────────────────────
python3 - <<EOF > "$RAW_DIR/run_order.txt"
import random

runs = $RUNS
scenarios = [s.strip() for s in "$SCENARIOS".split(",") if s.strip()]
if not scenarios:
    raise SystemExit("No scenarios configured.")

cases = []
for scenario in scenarios:
    cases.extend([("ssr", scenario)] * runs)
    cases.extend([("csr", scenario)] * runs)

random.shuffle(cases)
for condition, scenario in cases:
    print(f"{condition},{scenario}")
EOF

TOTAL_RUNS=$(wc -l < "$RAW_DIR/run_order.txt")
echo "Total runs scheduled: $TOTAL_RUNS"

echo "run,condition,scenario,temp_c,timestamp" > "$RAW_DIR/temperatures.csv"

RUN_NUM=0

while IFS=, read -r CONDITION SCENARIO <&3; do
  RUN_NUM=$((RUN_NUM + 1))

  URL=$([[ "$CONDITION" == "ssr" ]] && echo "$SSR_URL" || echo "$CSR_URL")
  PAGE_TEMPLATE=$([[ "$CONDITION" == "ssr" ]] && echo "$SSR_PAGES" || echo "$CSR_PAGES")
  PAGES="${PAGE_TEMPLATE//\{scenario\}/$SCENARIO}"

  TRACE_REMOTE="/data/misc/perfetto-traces/trace_${CONDITION}_${SCENARIO}_${RUN_NUM}"
  TRACE_LOCAL="$RAW_DIR/run_${RUN_NUM}_${CONDITION}_${SCENARIO}.perfetto-trace"
  METRICS_FILE="$RAW_DIR/run_${RUN_NUM}_${CONDITION}_${SCENARIO}.json"
  BATTERY_CSV="$RAW_DIR/run_${RUN_NUM}_${CONDITION}_${SCENARIO}.battery.csv"

  echo ""
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Run $RUN_NUM / $TOTAL_RUNS  ($CONDITION / $SCENARIO)"
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

  # ── 1. Cooldown ────────────────────────────────────────────────
  echo "→ Cooling down ${COOL_WAIT_S}s..."
  sleep "$COOL_WAIT_S"

  # ── 2. Temperature check ───────────────────────────────────────
  TEMP_RAW=$(adb -s "$DEVICE_ID" shell dumpsys battery | grep -m1 "temperature:" | awk '{print $2}' | tr -d '\r')
  [[ -z "$TEMP_RAW" ]] && TEMP_RAW=300
  TEMP_C=$(python3 -c "print(round($TEMP_RAW/10,1))")

  echo "$RUN_NUM,$CONDITION,$SCENARIO,$TEMP_C,$(date -u +%Y-%m-%dT%H:%M:%SZ)" >> "$RAW_DIR/temperatures.csv"
  echo "Temp: ${TEMP_C}°C"

  if (( $(echo "$TEMP_C > $MAX_TEMP_C" | bc -l) )); then
    echo "⚠ Too hot (>${MAX_TEMP_C}°C), skipping run..."
    continue
  fi

  # ── 3. Reset state ─────────────────────────────────────────────
  adb -s "$DEVICE_ID" shell am force-stop com.android.chrome
  sleep 1
  adb -s "$DEVICE_ID" shell input keyevent KEYCODE_HOME
  sleep 1

  # Brightness consistency
  adb -s "$DEVICE_ID" shell settings put system screen_brightness 120

  # Re-write Chrome command-line flags each run (survives force-stop)
  adb -s "$DEVICE_ID" shell "echo '--remote-debugging-port=9222' > /data/local/tmp/chrome-command-line"

  # Re-establish ADB tunnels each run (prevents silent drops mid-experiment)
  adb -s "$DEVICE_ID" reverse tcp:3000 tcp:3000 2>/dev/null || true
  adb -s "$DEVICE_ID" forward tcp:9222 localabstract:chrome_devtools_remote 2>/dev/null || true

  # ── 4. Start Perfetto ──────────────────────────────────────────
  PERFETTO_PID=$(
    adb -s "$DEVICE_ID" shell perfetto \
      --txt \
      --background \
      -c /data/misc/perfetto-configs/perfetto_config.pbtxt \
      -o "$TRACE_REMOTE" 2>&1 \
    | grep -oP '(?<=background pid: )\d+' || true
  )

  if [[ -z "$PERFETTO_PID" ]]; then
    echo "⚠ Could not get Perfetto PID — trace may be missing for this run"
  else
    echo "→ Perfetto started (pid: $PERFETTO_PID)"
  fi

  sleep 2

  # ── 5. Start battery poller ────────────────────────────────────
  start_battery_poller "$BATTERY_CSV"

  # ── 6. Run Puppeteer scenario ──────────────────────────────────
  node scripts/puppeteer-scenario.js \
    --url "$URL" \
    --condition "$CONDITION" \
    --scenario "$SCENARIO" \
    --run "$RUN_NUM" \
    --device-id "$DEVICE_ID" \
    --pages "$PAGES" \
    --out "$METRICS_FILE" \
    2>&1 | tee "$RAW_DIR/run_${RUN_NUM}_${CONDITION}_${SCENARIO}.log"

  stop_battery_poller

  # ── 7. Stop Perfetto ───────────────────────────────────────────
  if [[ -n "$PERFETTO_PID" ]]; then
    adb -s "$DEVICE_ID" shell kill -SIGINT "$PERFETTO_PID" 2>/dev/null || true
  else
    # Fallback: broad pkill (less safe but better than no stop)
    adb -s "$DEVICE_ID" shell pkill -SIGINT perfetto 2>/dev/null || true
  fi

  sleep 3

  # ── 8. Pull trace ──────────────────────────────────────────────
  if adb -s "$DEVICE_ID" pull "$TRACE_REMOTE" "$TRACE_LOCAL"; then
    adb -s "$DEVICE_ID" shell rm -f "$TRACE_REMOTE" 2>/dev/null || true
  else
    echo "⚠ First pull failed, retrying..."
    sleep 3
    if adb -s "$DEVICE_ID" pull "$TRACE_REMOTE" "$TRACE_LOCAL"; then
      adb -s "$DEVICE_ID" shell rm -f "$TRACE_REMOTE" 2>/dev/null || true
    else
      echo "✗ Could not pull trace for run $RUN_NUM — continuing"
    fi
  fi

  # ── 9. Sanity output ───────────────────────────────────────────
  if [[ -f "$METRICS_FILE" ]]; then
    LCP=$(python3 -c "
import json, sys
try:
    d = json.load(open('$METRICS_FILE'))
    pages = d.get('pages', [])
    val = (pages[0].get('metrics', {}) if pages else {}).get('lcp')
    print(f'{val:.0f}' if val else 'n/a')
except Exception as e:
    print('n/a')
" 2>/dev/null)
    echo "LCP: ${LCP} ms"
  fi

  if [[ -f "$TRACE_LOCAL" ]]; then
    SIZE=$(wc -c < "$TRACE_LOCAL" 2>/dev/null || echo 0)
    echo "Trace: $(echo "scale=1; $SIZE/1048576" | bc) MB"
  else
    echo "Trace: missing"
  fi

done 3< "$RAW_DIR/run_order.txt"

# ── Cleanup battery state ────────────────────────────────────────
adb -s "$DEVICE_ID" shell dumpsys battery reset >/dev/null 2>&1 || true

# ── Analysis ─────────────────────────────────────────────────────
echo ""
echo "→ Running analysis..."

python3 ../analysis/extract_energy.py --raw-dir "$RAW_DIR"
python3 ../analysis/analyze_runs.py   --raw-dir "$RAW_DIR"

# ── Move outputs ─────────────────────────────────────────────────
[[ -f "$RAW_DIR/energy_metrics.csv" ]] && mv -f "$RAW_DIR/energy_metrics.csv" "$PROCESSED_DIR/energy_metrics.csv"
[[ -f "$RAW_DIR/statistics.csv" ]]     && mv -f "$RAW_DIR/statistics.csv"     "$ANALYSIS_DIR/statistics.csv"
[[ -f "$RAW_DIR/report.md" ]]          && mv -f "$RAW_DIR/report.md"          "$ANALYSIS_DIR/report.md"
if [[ -d "$RAW_DIR/plots" ]]; then
  rm -rf "$ANALYSIS_DIR/plots"
  mv "$RAW_DIR/plots" "$ANALYSIS_DIR/plots"
fi

echo ""
echo "✓ Done"
echo "  raw:       $RAW_DIR"
echo "  processed: $PROCESSED_DIR"
echo "  analysis:  $ANALYSIS_DIR"