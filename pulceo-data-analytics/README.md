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
|---|--------------|-------------------------------------------------------|
| 0 | PDA | `rmarkdown::render(here('pulceo-data-analytics.Rmd'))` |
| 1 |  |  |
| 2 |  |  |
| 3 |  |  |
| 4 |  |  |
| 5 |  |  |
| 6 |  |  |
| 7 |  |  |
| 8 | Combined link quality | `rmarkdown::render(here('includes/metrics/combined-link-quality.Rmd'))` |
| 9 | Requests | `rmarkdown::render(here('includes/metrics/requests.Rmd'))` |