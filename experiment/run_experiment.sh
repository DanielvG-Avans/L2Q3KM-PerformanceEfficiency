#!/usr/bin/env bash
set -euo pipefail

# Helper script to make experiment runs repeatable and easy from any cwd.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Tunnel localhost port to Android device.
adb reverse tcp:3000 tcp:3000

# Run the main experiment script with localhost URLs.
bash "$SCRIPT_DIR/experiment.sh" \
  --ssr-url http://localhost:3000 \
  --csr-url http://localhost:3000 \
  --runs 30 \
  --scenarios static,dynamic,massive \
  --ssr-pages '/ssr?scenario={scenario}' \
  --csr-pages '/csr?scenario={scenario}'
