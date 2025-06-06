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
| 1 |  |  |
| 2 |  |  |
| 3 |  |  |
| 4 |  |  |
|  |  |  |
|  |  |  |
| 4 |  |  |
| 5 | Combined Utilization | `rmarkdown::render(here('includes/metrics/combined-util.Rmd'))` |
| 6 | Round-trip Time | `rmarkdown::render(here('includes/metrics/rtt.Rmd'))` |
| 7 | Bandwidth | `rmarkdown::render(here('includes/metrics/bw.Rmd'))` |
| 8 | Combined Link Quality | `rmarkdown::render(here('includes/metrics/combined-link-quality.Rmd'))` |
| 9 | Requests | `rmarkdown::render(here('includes/metrics/requests.Rmd'))` |