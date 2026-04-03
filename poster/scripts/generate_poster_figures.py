#!/usr/bin/env python3
"""Generate Dutch poster figures for the A1 beamerposter."""

from __future__ import annotations

import argparse
from pathlib import Path

import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd


REPO_ROOT = Path(__file__).resolve().parents[2]
DEFAULT_RUN_ID = "20260401_143839"
DEFAULT_RAW_DIR = REPO_ROOT / "data" / "runs" / DEFAULT_RUN_ID / "raw"
DEFAULT_ENERGY_CSV = REPO_ROOT / "data" / "runs" / DEFAULT_RUN_ID / "processed" / "energy_metrics.csv"
DEFAULT_OUTPUT_DIR = REPO_ROOT / "poster" / "figures"

SSR_COLOR = "#2E6FBE"
CSR_COLOR = "#F0625F"
INK = "#14324D"
MUTED = "#5A738C"
GRID = "#D8E6F2"
PANEL = "#F6FBFF"
ACCENT = "#D9F3FF"

SCENARIO_ORDER = ["static", "dynamic", "massive"]
SCENARIO_LABELS = {
    "static": "Statisch",
    "dynamic": "Dynamisch",
    "massive": "Massief",
}
SCENARIO_SIZE_LABELS = {
    "static": "72 records",
    "dynamic": "6.000 records",
    "massive": "24.000 records",
}
SCENARIO_SIZES = {
    "static": 72,
    "dynamic": 6000,
    "massive": 24000,
}


plt.rcParams.update(
    {
        "figure.dpi": 180,
        "savefig.dpi": 300,
        "font.family": "DejaVu Sans",
        "axes.titlesize": 17,
        "axes.labelsize": 13,
        "xtick.labelsize": 11.5,
        "ytick.labelsize": 11.5,
        "legend.fontsize": 11.5,
        "text.color": INK,
        "axes.labelcolor": INK,
        "axes.edgecolor": GRID,
        "xtick.color": INK,
        "ytick.color": INK,
    }
)


def style_axis(ax: plt.Axes) -> None:
    ax.set_facecolor(PANEL)
    ax.grid(axis="y", color=GRID, linewidth=1.0)
    ax.spines["top"].set_visible(False)
    ax.spines["right"].set_visible(False)
    ax.spines["left"].set_color(GRID)
    ax.spines["bottom"].set_color(GRID)
    ax.tick_params(length=0)


def load_statistics(path: Path) -> pd.DataFrame:
    df = pd.read_csv(path)
    return df


def load_energy_runs(path: Path) -> pd.DataFrame:
    df = pd.read_csv(path)
    return df[df["battery_energy_valid"] == True].copy()


def save_line_plot(stats_df: pd.DataFrame, output_dir: Path) -> None:
    energy_df = stats_df[stats_df["metric"] == "Total energy"].copy()
    energy_df["scenario"] = pd.Categorical(
        energy_df["scenario"], categories=SCENARIO_ORDER, ordered=True
    )
    energy_df["dataset_size"] = energy_df["scenario"].map(SCENARIO_SIZES)
    energy_df = energy_df.sort_values("scenario")

    x = np.arange(len(energy_df))
    ssr = energy_df["median_ssr"].to_numpy()
    csr = energy_df["median_csr"].to_numpy()

    fig, ax = plt.subplots(figsize=(8.6, 5.9))
    style_axis(ax)
    ax.plot(x, ssr, color=SSR_COLOR, marker="o", markersize=10, linewidth=3.2, label="SSR")
    ax.plot(x, csr, color=CSR_COLOR, marker="o", markersize=10, linewidth=3.2, label="CSR")
    ax.fill_between(x, ssr, csr, color=ACCENT, alpha=0.35, zorder=0)

    ax.set_ylabel("Mediane totale energie (mJ)")
    ax.set_xlabel("Scenario")
    ax.set_xticks(x)
    ax.set_xticklabels(
        [
            f"{SCENARIO_LABELS[row.scenario]}\n({SCENARIO_SIZE_LABELS[row.scenario]})"
            for row in energy_df.itertuples()
        ]
    )
    ax.legend(frameon=False, ncol=2, loc="upper left")
    ax.set_ylim(5400, max(csr.max(), ssr.max()) + 650)

    for idx, value in enumerate(ssr):
        ax.annotate(
            f"{value:.0f}",
            (x[idx], value),
            textcoords="offset points",
            xytext=(0, 14),
            ha="center",
            color=SSR_COLOR,
            fontsize=12,
            weight="bold",
        )

    for idx, value in enumerate(csr):
        ax.annotate(
            f"{value:.0f}",
            (x[idx], value),
            textcoords="offset points",
            xytext=(0, -20),
            ha="center",
            color=CSR_COLOR,
            fontsize=12,
            weight="bold",
        )

    fig.tight_layout()
    fig.savefig(output_dir / "energy-medians.pdf", bbox_inches="tight")
    plt.close(fig)


def save_energy_boxplots(energy_df: pd.DataFrame, output_dir: Path) -> None:
    fig, axes = plt.subplots(3, 1, figsize=(7.1, 8.9))

    for ax, scenario in zip(axes, SCENARIO_ORDER):
        style_axis(ax)
        subset = energy_df[energy_df["scenario"] == scenario]
        ssr = subset[subset["condition"] == "ssr"]["energy_total_mj"].dropna().to_numpy()
        csr = subset[subset["condition"] == "csr"]["energy_total_mj"].dropna().to_numpy()
        data = [ssr, csr]

        box = ax.boxplot(
            data,
            widths=0.5,
            patch_artist=True,
            medianprops={"color": INK, "linewidth": 2.2},
            whiskerprops={"color": MUTED, "linewidth": 1.2},
            capprops={"color": MUTED, "linewidth": 1.2},
            boxprops={"linewidth": 1.1},
        )

        for patch, color in zip(box["boxes"], [SSR_COLOR, CSR_COLOR]):
            patch.set_facecolor(color)
            patch.set_alpha(0.78)
            patch.set_edgecolor(color)

        rng = np.random.default_rng(20260403)
        for idx, (values, color) in enumerate(zip(data, [SSR_COLOR, CSR_COLOR]), start=1):
            jitter = rng.uniform(-0.09, 0.09, len(values))
            ax.scatter(
                np.full(len(values), idx) + jitter,
                values,
                color=color,
                s=26,
                alpha=0.35,
                linewidths=0,
                zorder=3,
            )

        ax.set_title(SCENARIO_LABELS[scenario], loc="left", pad=12, fontsize=16, weight="bold")
        ax.set_xticks([1, 2])
        ax.set_xticklabels(["SSR", "CSR"])
        ax.set_ylabel("Totale energie (mJ)")
        local_min = min(ssr.min(), csr.min())
        local_max = max(ssr.max(), csr.max())
        padding = max((local_max - local_min) * 0.12, 220)
        ax.set_ylim(local_min - padding, local_max + padding)
        ax.text(
            0.03,
            0.95,
            f"{SCENARIO_SIZE_LABELS[scenario]}",
            transform=ax.transAxes,
            va="top",
            fontsize=10.5,
            color=MUTED,
        )

    fig.tight_layout()
    fig.savefig(output_dir / "energy-boxplots.pdf", bbox_inches="tight")
    plt.close(fig)


def metric_value(stats_df: pd.DataFrame, metric: str, scenario: str, column: str) -> float:
    row = stats_df[(stats_df["metric"] == metric) & (stats_df["scenario"] == scenario)]
    if row.empty:
        raise ValueError(f"Missing {metric} for {scenario}")
    return float(row.iloc[0][column])


def save_tradeoff_plot(stats_df: pd.DataFrame, output_dir: Path) -> None:
    fig, axes = plt.subplots(3, 1, figsize=(6.3, 8.6))

    lcp = [metric_value(stats_df, "LCP — cold load", "dynamic", "median_ssr"), metric_value(stats_df, "LCP — cold load", "dynamic", "median_csr")]
    fcp = [metric_value(stats_df, "FCP — cold load", "dynamic", "median_ssr"), metric_value(stats_df, "FCP — cold load", "dynamic", "median_csr")]
    transfer_ssr = [metric_value(stats_df, "Navigation response size", scenario, "median_ssr") for scenario in SCENARIO_ORDER]
    transfer_csr = [metric_value(stats_df, "Navigation response size", scenario, "median_csr") for scenario in SCENARIO_ORDER]
    heap_ssr = [metric_value(stats_df, "JS heap sample", scenario, "median_ssr") for scenario in SCENARIO_ORDER]
    heap_csr = [metric_value(stats_df, "JS heap sample", scenario, "median_csr") for scenario in SCENARIO_ORDER]

    colors = [SSR_COLOR, CSR_COLOR]
    labels = ["SSR", "CSR"]
    offsets = np.array([-0.17, 0.17])

    ax = axes[0]
    style_axis(ax)
    x = np.arange(2)
    for idx, values in enumerate([lcp, fcp]):
        ax.bar(
            x + offsets[idx],
            values,
            width=0.30,
            color=[SSR_COLOR, CSR_COLOR] if idx == 0 else ["#76B7B2", "#FF9D76"],
            alpha=0.95,
            label="LCP" if idx == 0 else "FCP",
        )
    ax.set_xticks(x)
    ax.set_xticklabels(labels)
    ax.set_ylabel("Tijd (ms)")
    ax.set_title("Dynamisch: LCP en FCP", loc="left", fontsize=17, pad=12, weight="bold")
    ax.legend(frameon=False, ncol=2, loc="upper left")
    for xpos, value in zip(x + offsets[0], lcp):
        ax.text(xpos, value + 11, f"{value:.0f}", ha="center", va="bottom", fontsize=10.5, color=SSR_COLOR if xpos < 0.5 else CSR_COLOR)
    for xpos, value in zip(x + offsets[1], fcp):
        ax.text(xpos, value + 11, f"{value:.0f}", ha="center", va="bottom", fontsize=10.5, color="#2A837F" if xpos < 0.5 else "#D16A41")

    ax = axes[1]
    style_axis(ax)
    x = np.arange(len(SCENARIO_ORDER))
    ax.bar(x - 0.18, transfer_ssr, width=0.34, color=SSR_COLOR, label="SSR")
    ax.bar(x + 0.18, transfer_csr, width=0.34, color=CSR_COLOR, label="CSR")
    ax.set_xticks(x)
    ax.set_xticklabels([SCENARIO_LABELS[s] for s in SCENARIO_ORDER])
    ax.set_ylabel("KB")
    ax.set_title("Navigatierespons", loc="left", fontsize=17, pad=12, weight="bold")
    for xpos, value in zip(x - 0.18, transfer_ssr):
        ax.text(xpos, value + 0.08, f"{value:.1f}", ha="center", va="bottom", fontsize=10.5, color=SSR_COLOR)
    for xpos, value in zip(x + 0.18, transfer_csr):
        ax.text(xpos, value + 0.08, f"{value:.1f}", ha="center", va="bottom", fontsize=10.5, color=CSR_COLOR)

    ax = axes[2]
    style_axis(ax)
    x = np.arange(len(SCENARIO_ORDER))
    ax.bar(x - 0.18, heap_ssr, width=0.34, color=SSR_COLOR, label="SSR")
    ax.bar(x + 0.18, heap_csr, width=0.34, color=CSR_COLOR, label="CSR")
    ax.set_xticks(x)
    ax.set_xticklabels([SCENARIO_LABELS[s] for s in SCENARIO_ORDER])
    ax.set_ylabel("MB")
    ax.set_title("JS-heap-sample", loc="left", fontsize=17, pad=12, weight="bold")
    for xpos, value in zip(x - 0.18, heap_ssr):
        ax.text(xpos, value + 0.12, f"{value:.1f}", ha="center", va="bottom", fontsize=10.5, color=SSR_COLOR)
    for xpos, value in zip(x + 0.18, heap_csr):
        ax.text(xpos, value + 0.12, f"{value:.1f}", ha="center", va="bottom", fontsize=10.5, color=CSR_COLOR)

    fig.tight_layout()
    fig.savefig(output_dir / "browser-tradeoffs.pdf", bbox_inches="tight")
    plt.close(fig)


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--raw-dir", type=Path, default=DEFAULT_RAW_DIR)
    parser.add_argument("--energy-csv", type=Path, default=DEFAULT_ENERGY_CSV)
    parser.add_argument("--output-dir", type=Path, default=DEFAULT_OUTPUT_DIR)
    args = parser.parse_args()

    args.output_dir.mkdir(parents=True, exist_ok=True)

    stats_df = load_statistics(args.raw_dir / "statistics.csv")
    energy_df = load_energy_runs(args.energy_csv)

    save_line_plot(stats_df, args.output_dir)
    save_energy_boxplots(energy_df, args.output_dir)
    save_tradeoff_plot(stats_df, args.output_dir)


if __name__ == "__main__":
    main()
