# Research Project Repository

This repository contains the full SSR vs CSR performance and energy study: experiment scripts, raw/processed data, analysis, final results, and paper assets.

## Repository Structure

- `experiment/`: Measurement runner (`run.sh`), Perfetto config, Puppeteer scenario scripts, and benchmark dependencies.
- `prototype/`: Next.js SSR/CSR prototype app.
- `data/raw/`: Raw benchmark artifacts per run batch (traces, per-run metrics, logs, battery polling CSV).
- `data/processed/`: Processed metrics derived from raw batches (e.g., `energy_metrics.csv`).
- `analysis/`: Python parsers and statistical analysis scripts.
- `results/`: Final report artifacts used in the paper (`plots/`, `statistics.csv`, `report.md`).
- `paper/`: LaTeX manuscript and references.
- `docs/`: Proposal and supporting notes.

## Quick Start

```bash
# prototype app
cd prototype
npm install
npm run dev

# benchmark runner
cd ../experiment
npm install
pip install -r requirements.txt
bash run.sh --ssr-url http://YOUR_IP:3000 --csr-url http://YOUR_IP:3001 --runs 5
```
