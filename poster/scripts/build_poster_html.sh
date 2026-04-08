#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
POSTER_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)"
CHROME_BIN="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
HTML_FILE="${POSTER_DIR}/main.html"
PDF_FILE="${POSTER_DIR}/main.pdf"
PREVIEW_FILE="/private/tmp/poster_preview.png"
CHROME_FALLBACK_PDF="${HOME}/Downloads/main.pdf"

cd "${POSTER_DIR}"

if [[ -f figures/energy-medians.pdf ]]; then
  sips -s format png figures/energy-medians.pdf --resampleWidth 2200 --out figures/energy-medians.png >/dev/null
fi

if [[ -f figures/browser-tradeoffs.pdf ]]; then
  sips -s format png figures/browser-tradeoffs.pdf --resampleWidth 1800 --out figures/browser-tradeoffs.png >/dev/null
fi

if [[ -f figures/energy-boxplots.pdf ]]; then
  sips -s format png figures/energy-boxplots.pdf --resampleWidth 1800 --out figures/energy-boxplots.png >/dev/null
fi

"${CHROME_BIN}" \
  --headless=new \
  --disable-gpu \
  --allow-file-access-from-files \
  --run-all-compositor-stages-before-draw \
  --virtual-time-budget=2000 \
  --window-size=1920,1080 \
  --screenshot="${PREVIEW_FILE}" \
  "file://${HTML_FILE}" >/dev/null 2>&1

"${CHROME_BIN}" \
  --headless=new \
  --disable-gpu \
  --allow-file-access-from-files \
  --run-all-compositor-stages-before-draw \
  --virtual-time-budget=2000 \
  --window-size=1920,1080 \
  --print-to-pdf-no-header \
  --print-to-pdf="${PDF_FILE}" \
  "file://${HTML_FILE}" >/dev/null 2>&1

if [[ ! -f "${PDF_FILE}" && -f "${CHROME_FALLBACK_PDF}" ]]; then
  mv "${CHROME_FALLBACK_PDF}" "${PDF_FILE}"
fi

if [[ ! -f "${PDF_FILE}" ]]; then
  echo "Chrome did not produce ${PDF_FILE}" >&2
  exit 1
fi

echo "Built ${PDF_FILE}"
echo "Preview ${PREVIEW_FILE}"
