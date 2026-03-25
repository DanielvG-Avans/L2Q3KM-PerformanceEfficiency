#!/usr/bin/env python3
"""
analyze_runs.py — Generate statistics, report, and plots from run raw data.

Input:  data/runs/<timestamp>/raw (run_*.json files with metrics)
Output: statistics.csv, report.md, and plots/ in the same raw directory
"""

import argparse
import json
import sys
from pathlib import Path

import numpy as np
import pandas as pd
from scipy import stats
import matplotlib
matplotlib.use("Agg")
import matplotlib.pyplot as plt

plt.rcParams.update({
    "font.family": "serif", "font.size": 10,
    "axes.spines.top": False, "axes.spines.right": False,
    "figure.dpi": 150,
})


def load_data(raw_dir: Path) -> pd.DataFrame:
    rows = []
    for jf in sorted(raw_dir.glob("run_*.json")):
        with open(jf) as f:
            d = json.load(f)

        row = {
            "run":       d["meta"]["run"],
            "condition": d["meta"]["condition"],
        }

        # Energy
        e = d.get("energy", {})
        row["energy_total_mj"]  = e.get("energy_total_mj")
        row["avg_power_mw"]     = e.get("avg_power_mw")
        row["avg_cpu_freq_mhz"] = e.get("avg_cpu_freq_mhz")
        row["peak_memory_kb"]   = e.get("peak_memory_rss_kb")
        row["frame_janks"]      = e.get("frame_janks")

        # Browser metrics (aggregated from pages)
        pages = d.get("pages", [])
        if pages:
            p0 = pages[0]["metrics"]   # cold load page
            row["lcp_cold_ms"]   = p0.get("lcp")
            row["fcp_cold_ms"]   = p0.get("firstContentfulPaint")
            row["ttfb_cold_ms"]  = p0.get("ttfb")
            row["tbt_total_ms"]  = sum(p["metrics"].get("tbt", 0) for p in pages)
            row["cls_cold"]      = p0.get("cls")
            row["transfer_kb"]   = sum(
                (p["metrics"].get("transferSize") or 0) for p in pages
            ) / 1024
            if p0.get("jsHeap"):
                row["js_heap_mb"] = p0["jsHeap"].get("used_mb")

        rows.append(row)

    return pd.DataFrame(rows)


def mann_whitney(a: pd.Series, b: pd.Series, label: str) -> dict:
    a, b = a.dropna().values, b.dropna().values
    if len(a) < 3 or len(b) < 3:
        return {"metric": label, "note": "insufficient data"}

    stat, p = stats.mannwhitneyu(a, b, alternative="two-sided")
    r = 1 - 2 * stat / (len(a) * len(b))   # rank-biserial correlation
    mag = "negligible" if abs(r) < .1 else "small" if abs(r) < .3 else "medium" if abs(r) < .5 else "large"

    return {
        "metric": label,
        "n_ssr": len(a), "n_csr": len(b),
        "median_ssr": round(float(np.median(a)), 2),
        "iqr_ssr":    round(float(np.percentile(a, 75) - np.percentile(a, 25)), 2),
        "median_csr": round(float(np.median(b)), 2),
        "iqr_csr":    round(float(np.percentile(b, 75) - np.percentile(b, 25)), 2),
        "u_stat": round(float(stat), 1),
        "p_value": round(float(p), 5),
        "effect_r": round(float(r), 3),
        "effect_magnitude": mag,
        "direction": "SSR lower" if np.median(a) < np.median(b) else "CSR lower",
    }


def boxplot(ssr: pd.Series, csr: pd.Series, title: str, unit: str, path: str):
    fig, ax = plt.subplots(figsize=(3.5, 4))
    data = [ssr.dropna().values, csr.dropna().values]
    bp = ax.boxplot(data, patch_artist=True, widths=0.45,
                    medianprops={"color": "black", "linewidth": 1.8})
    for patch, col in zip(bp["boxes"], ["#4E79A7", "#E15759"]):
        patch.set_facecolor(col); patch.set_alpha(0.65)
    for i, (vals, col) in enumerate(zip(data, ["#4E79A7", "#E15759"]), 1):
        jitter = np.random.uniform(-0.07, 0.07, len(vals))
        ax.scatter(np.full(len(vals), i) + jitter, vals, s=10, alpha=0.35, c=col, zorder=3)
    ax.set_xticks([1, 2]); ax.set_xticklabels(["SSR", "CSR"])
    ax.set_ylabel(f"{title} ({unit})"); ax.set_title(title, fontsize=10, pad=6)
    plt.tight_layout()
    plt.savefig(path, bbox_inches="tight"); plt.close()


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--raw-dir", help="Path to a run raw directory (preferred).")
    parser.add_argument("--results-dir", help="Deprecated alias of --raw-dir.")
    args = parser.parse_args()

    raw_dir_arg = args.raw_dir or args.results_dir
    if not raw_dir_arg:
        parser.error("one of --raw-dir or --results-dir is required")

    rd = Path(raw_dir_arg)
    if args.results_dir and not args.raw_dir:
        print("[analyze_runs] INFO: --results-dir is deprecated; use --raw-dir.")

    df = load_data(rd)
    if df.empty:
        print("[analyze_runs] No data."); sys.exit(1)

    ssr = df[df["condition"] == "ssr"]
    csr = df[df["condition"] == "csr"]
    print(f"[analyze_runs] {len(ssr)} SSR runs, {len(csr)} CSR runs loaded")

    metrics = [
        ("energy_total_mj",  "Total energy",              "mJ"),
        ("avg_power_mw",     "Average power",             "mW"),
        ("lcp_cold_ms",      "LCP — cold load",           "ms"),
        ("fcp_cold_ms",      "FCP — cold load",           "ms"),
        ("ttfb_cold_ms",     "TTFB — cold load",          "ms"),
        ("tbt_total_ms",     "Total Blocking Time (all pages)", "ms"),
        ("cls_cold",         "CLS — cold load",           "score"),
        ("transfer_kb",      "Transfer size (all pages)", "KB"),
        ("js_heap_mb",       "JS heap peak",              "MB"),
        ("peak_memory_kb",   "Peak RSS (Perfetto)",       "KB"),
        ("avg_cpu_freq_mhz", "Avg CPU frequency",         "MHz"),
        ("frame_janks",      "Frame janks",               "count"),
    ]

    plots_dir = rd / "plots"; plots_dir.mkdir(exist_ok=True)
    results = []

    for col, label, unit in metrics:
        if col not in df.columns or df[col].dropna().empty:
            continue
        r = mann_whitney(ssr[col], csr[col], label)
        results.append(r)
        if "p_value" in r:
            print(f"  {label:35s} SSR={r['median_ssr']:8.1f}  CSR={r['median_csr']:8.1f}  "
                  f"p={r['p_value']:.4f}  r={r['effect_r']:.3f} ({r['effect_magnitude']})")
        try:
            boxplot(ssr[col], csr[col], label, unit, str(plots_dir / f"{col}.png"))
        except Exception: pass

    # ── Save stats ─────────────────────────────────────────────────────────────
    stats_df = pd.DataFrame(results)
    stats_df.to_csv(rd / "statistics.csv", index=False)

    # ── Bonferroni-corrected significance threshold ────────────────────────────
    n_tests = len([r for r in results if "p_value" in r])
    alpha_b = 0.05 / n_tests if n_tests else 0.05

    # ── Markdown report ────────────────────────────────────────────────────────
    lines = [
        "# SSR vs CSR Benchmark — Results",
        "",
        f"**Device:** Samsung SM-A536B (Galaxy A53), Android 16, SDK 36  ",
        f"**Energy method:** Battery current × voltage integration (250ms polling, Perfetto)  ",
        f"**Statistical test:** Mann-Whitney U, two-sided, α = 0.05  ",
        f"**Bonferroni-corrected threshold:** α = {alpha_b:.4f} ({n_tests} tests)  ",
        "",
        "## Results table",
        "",
        "| Metric | SSR median (IQR) | CSR median (IQR) | *p* | Effect *r* | Sig |",
        "|--------|-----------------|-----------------|-----|-----------|-----|",
    ]
    for r in results:
        if "p_value" not in r: continue
        sig = "✓" if r["p_value"] < alpha_b else "–"
        pstr = f"{r['p_value']:.4f}" if r["p_value"] >= 0.0001 else "<0.0001"
        lines.append(
            f"| {r['metric']} "
            f"| {r['median_ssr']:.1f} (±{r['iqr_ssr']:.1f}) "
            f"| {r['median_csr']:.1f} (±{r['iqr_csr']:.1f}) "
            f"| {pstr} | {r['effect_r']:.3f} ({r['effect_magnitude']}) | {sig} |"
        )
    lines += [
        "",
        "## Methodology notes",
        "",
        "- All runs interleaved in randomised order to prevent thermal session bias.",
        "- Chrome force-stopped before each run; no app-data wipe between runs.",
        "- Screen brightness fixed at 120/255 (manual mode) throughout.",
        "- Device radios: WiFi only (mobile data, Bluetooth, NFC disabled).",
        "- Device idle ≥45s between runs; runs discarded if start temp >37°C.",
        "- Energy computed as ∫ |I(t)| × V(t) dt over trace window (trapezoidal rule).",
        "- SM-A536B does not expose hardware power rail counters; battery polling used.",
        "",
    ]
    (rd / "report.md").write_text("\n".join(lines))
    print(f"\n[analyze_runs] OK: report.md, statistics.csv, plots/ saved in {rd}")


if __name__ == "__main__":
    main()
