# PULCEO-DATA-ANALYTICS

-   `raw/`: Contains raw data
-   `reports/`: Contains generated orchestration reports

## How to test

``` r
library(here)
library(rmarkdown)
```

### Includes

| \#  | Resource | Command                                                    |
|---|-----------|----------------------------------------------------------|
| 1   | Requests | `rmarkdown::render(here('includes/metrics/requests.Rmd'))` |
| 2   |          |                                                            |
| 3   |          |                                                            |