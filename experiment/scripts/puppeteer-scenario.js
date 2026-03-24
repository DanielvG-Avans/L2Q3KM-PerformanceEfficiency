#!/usr/bin/env node
// =============================================================================
// Browser scenario via Chrome DevTools Protocol
//
// Works by forwarding the Chrome CDP port over ADB:
//   adb forward tcp:9222 localabstract:chrome_devtools_remote
// (run.sh handles this automatically)
//
// IMPORTANT — Samsung A53 note:
// Chrome on Samsung One UI may show a "Chrome isn't your default browser"
// banner on first ever launch after factory reset you may need to manually
// dismiss it once. This steals focus and can delay metrics!
//
// Usage (called by run.sh — not run manually):
//   node scripts/puppeteer-scenario.js \
//     --url http://192.168.x.x:3000 \
//     --condition ssr \
//     --run 1 \
//     --out results/run_1_ssr.json
// =============================================================================

const puppeteer = require("puppeteer-core");
const fs = require("fs");
const { execSync } = require("child_process");

// ── Parse args ────────────────────────────────────────────────────────────────
const argv = {};
for (let i = 2; i < process.argv.length - 1; i += 2) {
  argv[process.argv[i].replace("--", "")] = process.argv[i + 1];
}
const { url, condition, run, out, deviceId } = argv;
if (!url || !condition || !run || !out) {
  process.stderr.write(
    "Missing required args: --url --condition --run --out\n",
  );
  process.exit(1);
}

const ADB_PREFIX = deviceId ? `adb -s "${deviceId}"` : "adb";

// ── Pages to navigate (edit these to match your app routes) ──────────────────
// These must exist in BOTH your SSR and CSR apps.
// Keep the list at 3 pages: 1 cold load + 2 navigations is enough to capture
// both the initial-load advantage (SSR) and subsequent-navigation behaviour (CSR).
const PAGES = [
  "/", // Home — cold load
  "/about", // Page 2 — first navigation
  "/products", // Page 3 — second navigation
];

const DWELL_MS = 1000; // Time to "read" each page before navigating
const LOAD_TIMEOUT_MS = 30000;
const SETTLE_MS_CSR = 800; // Extra settle for React hydration on CSR
const CDP_READY_TIMEOUT_MS = 15000;
const CDP_POLL_MS = 500;

// ── Helpers ───────────────────────────────────────────────────────────────────
async function getMetrics(page) {
  // Performance timing, paint, LCP, TBT, CLS, resource summary
  const data = await page.evaluate(() => {
    const nav = performance.getEntriesByType("navigation")[0];
    const paint = performance.getEntriesByType("paint");
    const lcp = performance.getEntriesByType("largest-contentful-paint");
    const lt = performance.getEntriesByType("longtask");
    const ls = performance.getEntriesByType("layout-shift");
    const resources = performance.getEntriesByType("resource");

    return {
      ttfb: nav ? nav.responseStart - nav.requestStart : null,
      domContentLoaded: nav
        ? nav.domContentLoadedEventEnd - nav.startTime
        : null,
      loadComplete: nav ? nav.loadEventEnd - nav.startTime : null,
      transferSize: nav ? nav.transferSize : null,

      firstPaint:
        paint.find((e) => e.name === "first-paint")?.startTime ?? null,
      firstContentfulPaint:
        paint.find((e) => e.name === "first-contentful-paint")?.startTime ??
        null,
      lcp: lcp.length > 0 ? lcp[lcp.length - 1].startTime : null,

      // Total Blocking Time = sum of (task_duration - 50ms) for long tasks
      tbt: lt.reduce((s, t) => s + Math.max(0, t.duration - 50), 0),

      // Cumulative Layout Shift
      cls: ls.reduce((s, e) => s + (e.value || 0), 0),

      resources: resources.map((r) => ({
        name: r.name.split("/").slice(-2).join("/"),
        type: r.initiatorType,
        size_kb: Math.round(r.transferSize / 1024),
        duration: Math.round(r.duration),
      })),

      jsHeap: performance.memory
        ? {
            used_mb:
              Math.round((performance.memory.usedJSHeapSize / 1048576) * 10) /
              10,
            total_mb:
              Math.round((performance.memory.totalJSHeapSize / 1048576) * 10) /
              10,
          }
        : null,
    };
  });

  return data;
}

async function waitForCdpReady(timeoutMs) {
  const start = Date.now();
  const endpoint = "http://localhost:9222/json/version";

  while (Date.now() - start < timeoutMs) {
    try {
      const res = await fetch(endpoint);
      if (res.ok) {
        return true;
      }
    } catch (_) {
      // Keep polling until timeout.
    }
    await new Promise((r) => setTimeout(r, CDP_POLL_MS));
  }

  return false;
}

// ── Main ──────────────────────────────────────────────────────────────────────
(async () => {
  const result = {
    meta: {
      run: parseInt(run),
      condition,
      url,
      timestamp: new Date().toISOString(),
      pages_tested: PAGES,
    },
    pages: [],
    errors: [],
  };

  let browser = null;

  try {
    // Ensure Chrome is launched before connecting to CDP.
    // On Android, the devtools socket may not exist until Chrome is running.
    execSync(
      `${ADB_PREFIX} shell am start -a android.intent.action.VIEW -d "${url}"`,
      {
        stdio: "pipe",
        timeout: 5000,
      },
    );

    const cdpReady = await waitForCdpReady(CDP_READY_TIMEOUT_MS);
    if (!cdpReady) {
      throw new Error(
        "DevTools endpoint not ready at http://localhost:9222/json/version",
      );
    }

    // Connect to Chrome on device via DevTools Protocol.
    // Chrome must have been opened at least once after pm clear.
    // run.sh opens Chrome by navigating to the URL, which is fine.
    browser = await puppeteer.connect({
      browserURL: "http://localhost:9222",
      defaultViewport: { width: 390, height: 844 }, // Mobile viewport
    });

    const page = await browser.newPage();

    // Intercept Chrome's "set as default browser" popup by dismissing dialogs
    page.on("dialog", async (dialog) => {
      await dialog.dismiss().catch(() => {});
    });

    // Observe LCP and CLS from the start
    await page.evaluateOnNewDocument(() => {
      window.__obs = { lcp: null, cls: 0 };
      new PerformanceObserver((list) => {
        const e = list.getEntries();
        if (e.length) window.__obs.lcp = e[e.length - 1].startTime;
      }).observe({ type: "largest-contentful-paint", buffered: true });
      new PerformanceObserver((list) => {
        list.getEntries().forEach((e) => {
          window.__obs.cls += e.value || 0;
        });
      }).observe({ type: "layout-shift", buffered: true });
    });

    for (let i = 0; i < PAGES.length; i++) {
      const pageUrl = `${url.replace(/\/$/, "")}${PAGES[i]}`;
      process.stdout.write(
        `  [puppeteer] ${i + 1}/${PAGES.length} → ${pageUrl}\n`,
      );

      const t0 = Date.now();

      await page.goto(pageUrl, {
        waitUntil: "networkidle2",
        timeout: LOAD_TIMEOUT_MS,
      });

      // CSR apps need extra time for React hydration after networkidle2
      if (condition === "csr") {
        await new Promise((r) => setTimeout(r, SETTLE_MS_CSR));
      }

      const metrics = await getMetrics(page);
      const obs = await page.evaluate(() => window.__obs || {});

      // LCP from PerformanceObserver is more reliable than from getEntries()
      // because it fires asynchronously after paint
      if (obs.lcp && !metrics.lcp) {
        metrics.lcp = obs.lcp;
      }

      result.pages.push({
        page_index: i,
        path: PAGES[i],
        nav_ms: Date.now() - t0,
        metrics,
      });

      process.stdout.write(
        `  [puppeteer]   LCP=${metrics.lcp?.toFixed(0) ?? "n/a"}ms  ` +
          `FCP=${metrics.firstContentfulPaint?.toFixed(0) ?? "n/a"}ms  ` +
          `TBT=${metrics.tbt?.toFixed(0) ?? "n/a"}ms  ` +
          `TTFB=${metrics.ttfb?.toFixed(0) ?? "n/a"}ms\n`,
      );

      // Dwell time (simulate user reading)
      await new Promise((r) => setTimeout(r, DWELL_MS));
    }

    await page.close();
  } catch (err) {
    process.stderr.write(`  [puppeteer] ERROR: ${err.message}\n`);
    result.errors.push({ message: err.message });

    // Fallback: if CDP fails, use am start and record no DevTools metrics
    // This ensures the Perfetto trace still captures energy data even if
    // the DevTools connection fails.
    if (url) {
      process.stdout.write(
        "  [puppeteer] Falling back to am start (Perfetto trace still valid)\n",
      );
      try {
        execSync(
          `${ADB_PREFIX} shell am start -a android.intent.action.VIEW -d "${url}"`,
          {
            stdio: "pipe",
            timeout: 5000,
          },
        );
        await new Promise((r) => setTimeout(r, 20000)); // 20s wait for load
        result.meta.fallback = "am_start_no_devtools_metrics";
      } catch (e2) {
        result.errors.push({
          message: "am start fallback also failed: " + e2.message,
        });
      }
    }
  } finally {
    if (browser) {
      await browser.disconnect().catch(() => {});
    }
  }

  fs.writeFileSync(out, JSON.stringify(result, null, 2));
  process.stdout.write(`  [puppeteer] ✓ Saved → ${out}\n`);
})();
