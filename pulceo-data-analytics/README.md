# PULCEO-DATA-ANALYTICS

-   `raw/`: Contains raw data
-   `reports/`: Contains generated orchestration reports

## How to test

``` r
library(here)
library(rmarkdown)
```

### Includes

| \# | Resource | Command |
|---|--------------|--------------------------------------------------------|
| 0 | PDA | `rmarkdown::render(here('pulceo-data-analytics.Rmd'))` |
| 0 | Topology | `rmarkdown::render(here(''))` |
| 0 | Resources | `rmarkdown::render(here(''))` |

| 1 | CPU Utilization  | `rmarkdown::render(here('includes/metrics/cpu-util.Rmd'))` |
| 2 | Memory Utilization  | `rmarkdown::render(here('includes/metrics/mem-util.Rmd'))`  |
| 3 | Storage Utilization  | `rmarkdown::render(here('includes/metrics/storage-util.Rmd'))` |
| 4 | Network Utilization  | `rmarkdown::render(here('includes/metrics/net-util.Rmd'))`  |
| 5 | Combined Utilization | `rmarkdown::render(here('includes/metrics/combined-util.Rmd'))` |
| 6 | Round-trip Time | `rmarkdown::render(here('includes/metrics/rtt.Rmd'))` |
| 7 | Bandwidth | `rmarkdown::render(here('includes/metrics/bw.Rmd'))` |
| 8 | Combined Link Quality | `rmarkdown::render(here('includes/metrics/combined-link-quality.Rmd'))` |
| 9 | Requests | `rmarkdown::render(here('includes/metrics/requests.Rmd'))` |
