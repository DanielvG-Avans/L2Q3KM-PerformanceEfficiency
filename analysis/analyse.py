#!/usr/bin/env python3
"""
Backward-compatible wrapper. Prefer:
  python3 analysis/analyze_runs.py --results-dir <raw-run-dir>
"""

from analyze_runs import main


if __name__ == "__main__":
    main()
