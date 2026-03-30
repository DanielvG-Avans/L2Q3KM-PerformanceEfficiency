# SSR vs CSR Benchmark — Results

**Device:** Samsung SM-A536B (Galaxy A53), Android 16, SDK 36  
**Direct energy method:** Battery current × voltage integration (250ms polling)  
**Proxy energy method:** Perfetto CPU frequency residency weighted by core class  
**Statistical test:** Mann-Whitney U, two-sided, α = 0.05  
**Bonferroni-corrected threshold:** α = 0.0019 (27 tests)  

## Results table

| Scenario | Metric | SSR median (IQR) | CSR median (IQR) | *p* | Effect *r* | Sig |
|----------|--------|------------------|------------------|-----|-----------|-----|
| dynamic | Total energy | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| dynamic | Average power | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| dynamic | LCP — cold load | 3258.0 (±18.0) | 3260.0 (±15.0) | 0.4618 | 0.111 (small) | – |
| dynamic | FCP — cold load | 3258.0 (±18.0) | 3260.0 (±15.0) | 0.4618 | 0.111 (small) | – |
| dynamic | TTFB — cold load | 32.0 (±54.7) | 27.8 (±86.6) | 0.9352 | -0.013 (negligible) | – |
| dynamic | Total Blocking Time (all pages) | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| dynamic | CLS — cold load | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| dynamic | Transfer size (all pages) | 0.3 (±0.0) | 0.3 (±0.0) | 1.0000 | -0.001 (negligible) | – |
| dynamic | JS heap peak | 9.5 (±0.0) | 9.5 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| massive | Total energy | 0.0 (±0.0) | 0.0 (±0.0) | 0.5972 | 0.031 (negligible) | – |
| massive | Average power | 0.0 (±0.0) | 0.0 (±0.0) | 0.5972 | 0.031 (negligible) | – |
| massive | LCP — cold load | 3256.0 (±26.0) | 3260.0 (±16.0) | 0.6555 | 0.068 (negligible) | – |
| massive | FCP — cold load | 3256.0 (±26.0) | 3260.0 (±16.0) | 0.6555 | 0.068 (negligible) | – |
| massive | TTFB — cold load | 24.6 (±25.6) | 31.6 (±74.8) | 0.6309 | 0.073 (negligible) | – |
| massive | Total Blocking Time (all pages) | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| massive | CLS — cold load | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| massive | Transfer size (all pages) | 0.3 (±0.0) | 0.3 (±0.0) | 1.0000 | -0.001 (negligible) | – |
| massive | JS heap peak | 9.5 (±0.0) | 9.5 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| static | Total energy | 0.0 (±0.0) | 0.0 (±0.0) | 0.3050 | 0.068 (negligible) | – |
| static | Average power | 0.0 (±0.0) | 0.0 (±0.0) | 0.3050 | 0.068 (negligible) | – |
| static | LCP — cold load | 3256.0 (±16.0) | 3262.0 (±23.0) | 0.1204 | 0.233 (small) | – |
| static | FCP — cold load | 3256.0 (±16.0) | 3262.0 (±23.0) | 0.1204 | 0.233 (small) | – |
| static | TTFB — cold load | 21.9 (±31.8) | 20.3 (±36.8) | 0.8303 | -0.033 (negligible) | – |
| static | Total Blocking Time (all pages) | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| static | CLS — cold load | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| static | Transfer size (all pages) | 0.3 (±0.0) | 0.3 (±0.0) | 1.0000 | -0.001 (negligible) | – |
| static | JS heap peak | 9.5 (±0.0) | 9.5 (±0.0) | 1.0000 | 0.000 (negligible) | – |

## Methodology notes

- All runs interleaved in randomised order to prevent thermal session bias.
- Chrome force-stopped before each run; no app-data wipe between runs.
- Screen brightness fixed at 120/255 (manual mode) throughout.
- Device radios: WiFi only (mobile data, Bluetooth, NFC disabled).
- Device idle ≥45s between runs; runs discarded if start temp >37°C.
- Energy computed as ∫ |I(t)| × V(t) dt over trace window (trapezoidal rule).
- Battery-current energy under USB-connected runs may be contaminated by external power and should be treated cautiously when many samples are zero-current.
- CPU energy proxy is an inference from Perfetto CPU frequency residency, weighted more heavily for big cores; it supports relative SSR/CSR comparison, not absolute joule claims.
- SM-A536B does not expose hardware power rail counters; battery polling used.
- Runs without a working CDP connection remain usable for system-level trace and energy analysis, but browser-level metrics are excluded when unavailable.
