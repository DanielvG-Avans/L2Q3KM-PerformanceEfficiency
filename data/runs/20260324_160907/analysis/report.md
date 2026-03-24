# SSR vs CSR Benchmark — Results

**Device:** Samsung SM-A536B (Galaxy A53), Android 16, SDK 36  
**Energy method:** Battery current × voltage integration (250ms polling, Perfetto)  
**Statistical test:** Mann-Whitney U, two-sided, α = 0.05  
**Bonferroni-corrected threshold:** α = 0.0045 (11 tests)

## Results table

| Metric                          | SSR median (IQR)  | CSR median (IQR)   | _p_    | Effect _r_         | Sig |
| ------------------------------- | ----------------- | ------------------ | ------ | ------------------ | --- |
| Total energy                    | 26143.0 (±2401.7) | 36862.8 (±17617.6) | 0.5476 | 0.280 (small)      | –   |
| Average power                   | 1040.9 (±58.8)    | 1407.2 (±636.6)    | 0.4206 | 0.360 (medium)     | –   |
| LCP — cold load                 | 6398.0 (±56.0)    | 6356.0 (±108.0)    | 0.7302 | -0.200 (small)     | –   |
| FCP — cold load                 | 6398.0 (±56.0)    | 6356.0 (±108.0)    | 0.7302 | -0.200 (small)     | –   |
| TTFB — cold load                | 70.0 (±32.4)      | 94.1 (±25.1)       | 0.7302 | 0.200 (small)      | –   |
| Total Blocking Time (all pages) | 0.0 (±0.0)        | 0.0 (±0.0)         | 1.0000 | 0.000 (negligible) | –   |
| CLS — cold load                 | 0.0 (±0.0)        | 0.0 (±0.0)         | 1.0000 | 0.000 (negligible) | –   |
| Transfer size (all pages)       | 5.2 (±0.0)        | 5.2 (±0.0)         | 1.0000 | 0.000 (negligible) | –   |
| JS heap peak                    | 16.3 (±0.3)       | 9.5 (±0.0)         | 0.0093 | -1.000 (large)     | –   |
| Avg CPU frequency               | 1058.7 (±32.6)    | 981.0 (±5.7)       | 0.1508 | -0.600 (large)     | –   |
| Frame janks                     | 0.0 (±0.0)        | 0.0 (±0.0)         | 1.0000 | 0.000 (negligible) | –   |

## Methodology notes

- All runs interleaved in randomised order to prevent thermal session bias.
- Chrome cleared via `pm clear com.android.chrome` before each run (cold JIT, cold cache).
- Screen brightness fixed at 120/255 (manual mode) throughout.
- Device radios: WiFi only (mobile data, Bluetooth, NFC disabled).
- Device idle ≥45s between runs; runs discarded if start temp >37°C.
- Energy computed as ∫ |I(t)| × V(t) dt over trace window (trapezoidal rule).
- SM-A536B does not expose hardware power rail counters; battery polling used.
