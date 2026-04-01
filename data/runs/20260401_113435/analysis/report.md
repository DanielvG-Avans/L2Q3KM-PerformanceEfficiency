# SSR vs CSR Benchmark — Results

**Device:** Samsung SM-A536B (Galaxy A53), Android 16, SDK 36  
**Direct energy method:** Battery current × voltage integration (250ms polling)  
**Proxy energy method:** Perfetto CPU frequency residency weighted by core class  
**Statistical test:** Mann-Whitney U, two-sided, α = 0.05  
**Bonferroni-corrected threshold:** α = 0.0019 (27 tests)  

## Results table

| Scenario | Metric | SSR median (IQR) | CSR median (IQR) | *p* | Effect *r* | Sig |
|----------|--------|------------------|------------------|-----|-----------|-----|
| dynamic | Total energy | 6732.7 (±926.4) | 6537.6 (±693.1) | 0.9698 | -0.020 (negligible) | – |
| dynamic | Average power | 938.0 (±193.2) | 790.5 (±104.8) | 0.0211 | -0.620 (large) | – |
| dynamic | LCP — cold load | 3290.0 (±18.0) | 3272.0 (±15.0) | 0.0056 | -0.740 (large) | – |
| dynamic | FCP — cold load | 3290.0 (±18.0) | 3272.0 (±15.0) | 0.0056 | -0.740 (large) | – |
| dynamic | TTFB — cold load | 26.1 (±11.1) | 17.9 (±5.6) | 0.0211 | -0.620 (large) | – |
| dynamic | Total Blocking Time (all pages) | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| dynamic | CLS — cold load | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| dynamic | Transfer size (all pages) | 7.1 (±0.0) | 3.9 (±0.0) | <0.0001 | -1.000 (large) | ✓ |
| dynamic | JS heap peak | 9.5 (±0.0) | 9.5 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| massive | Total energy | 5910.7 (±2290.9) | 7017.0 (±904.2) | 0.1620 | 0.380 (medium) | – |
| massive | Average power | 821.0 (±294.8) | 821.0 (±165.7) | 0.9698 | -0.020 (negligible) | – |
| massive | LCP — cold load | 3288.0 (±7.0) | 3270.0 (±25.0) | 0.0675 | -0.490 (medium) | – |
| massive | FCP — cold load | 3288.0 (±7.0) | 3270.0 (±25.0) | 0.0675 | -0.490 (medium) | – |
| massive | TTFB — cold load | 28.2 (±12.5) | 19.9 (±3.5) | 0.0493 | -0.530 (large) | – |
| massive | Total Blocking Time (all pages) | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| massive | CLS — cold load | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| massive | Transfer size (all pages) | 7.1 (±0.0) | 3.9 (±0.0) | <0.0001 | -1.000 (large) | ✓ |
| massive | JS heap peak | 9.5 (±0.0) | 9.5 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| static | Total energy | 6864.6 (±2693.7) | 7996.9 (±6021.8) | 0.1212 | 0.420 (medium) | – |
| static | Average power | 837.6 (±355.6) | 834.5 (±777.6) | 0.8501 | -0.060 (negligible) | – |
| static | LCP — cold load | 3278.0 (±19.0) | 3282.0 (±12.0) | 0.9695 | -0.020 (negligible) | – |
| static | FCP — cold load | 3278.0 (±19.0) | 3282.0 (±12.0) | 0.9695 | -0.020 (negligible) | – |
| static | TTFB — cold load | 23.4 (±2.8) | 17.9 (±8.0) | 0.0539 | -0.520 (large) | – |
| static | Total Blocking Time (all pages) | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| static | CLS — cold load | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| static | Transfer size (all pages) | 7.1 (±0.0) | 3.9 (±0.0) | <0.0001 | -1.000 (large) | ✓ |
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
