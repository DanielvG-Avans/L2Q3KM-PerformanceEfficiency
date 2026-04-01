# SSR vs CSR Benchmark — Results

**Device:** Samsung SM-A536B (Galaxy A53), Android 16, SDK 36  
**Direct energy method:** Battery current × voltage integration (250ms polling)  
**Proxy energy method:** Perfetto CPU frequency residency weighted by core class  
**Statistical test:** Mann-Whitney U, two-sided, α = 0.05  
**Bonferroni-corrected threshold:** α = 0.0019 (27 tests)  

## Results table

| Scenario | Metric | SSR median (IQR) | CSR median (IQR) | *p* | Effect *r* | Sig |
|----------|--------|------------------|------------------|-----|-----------|-----|
| dynamic | Total energy | 6256.2 (±1518.0) | 7786.9 (±2499.7) | 0.0890 | 0.460 (medium) | – |
| dynamic | Average power | 799.5 (±266.8) | 885.2 (±292.8) | 0.9698 | 0.020 (negligible) | – |
| dynamic | LCP — cold load | 3284.0 (±22.0) | 3266.0 (±11.0) | 0.0308 | -0.580 (large) | – |
| dynamic | FCP — cold load | 3284.0 (±22.0) | 3266.0 (±11.0) | 0.0371 | -0.560 (large) | – |
| dynamic | TTFB — cold load | 32.1 (±33.1) | 24.8 (±107.4) | 0.4274 | -0.220 (small) | – |
| dynamic | Total Blocking Time (all pages) | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| dynamic | CLS — cold load | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| dynamic | Transfer size (all pages) | 7.1 (±0.0) | 3.9 (±0.0) | <0.0001 | -1.000 (large) | ✓ |
| dynamic | JS heap peak | 9.5 (±0.0) | 9.5 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| massive | Total energy | 6088.7 (±2757.1) | 6497.3 (±2097.3) | 0.3075 | 0.280 (small) | – |
| massive | Average power | 814.4 (±321.3) | 749.4 (±273.3) | 0.6232 | -0.140 (small) | – |
| massive | LCP — cold load | 3290.0 (±16.0) | 3272.0 (±8.0) | 0.0191 | -0.620 (large) | – |
| massive | FCP — cold load | 3290.0 (±16.0) | 3272.0 (±8.0) | 0.0191 | -0.620 (large) | – |
| massive | TTFB — cold load | 26.5 (±6.3) | 20.2 (±10.3) | 0.1405 | -0.400 (medium) | – |
| massive | Total Blocking Time (all pages) | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| massive | CLS — cold load | 0.0 (±0.0) | 0.0 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| massive | Transfer size (all pages) | 7.1 (±0.0) | 3.9 (±0.0) | <0.0001 | -1.000 (large) | ✓ |
| massive | JS heap peak | 9.5 (±0.0) | 9.5 (±0.0) | 1.0000 | 0.000 (negligible) | – |
| static | Total energy | 6087.8 (±1985.8) | 6754.3 (±4636.3) | 0.0640 | 0.500 (large) | – |
| static | Average power | 795.4 (±212.4) | 789.1 (±617.0) | 0.7913 | 0.080 (negligible) | – |
| static | LCP — cold load | 3298.0 (±7.0) | 3276.0 (±20.0) | 0.0055 | -0.740 (large) | – |
| static | FCP — cold load | 3298.0 (±7.0) | 3274.0 (±29.0) | 0.0043 | -0.760 (large) | – |
| static | TTFB — cold load | 28.1 (±16.4) | 27.1 (±83.8) | 0.8501 | -0.060 (negligible) | – |
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
