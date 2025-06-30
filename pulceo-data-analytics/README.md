# PULCEO-DATA-ANALYTICS

- `raw/`: Contains raw data
- `reports/`: Contains generated orchestration reports

## How to test

``` r
library(here)
library(rmarkdown)
```

Specify the project to render:

```r
ROOTFOLDER <- "/tmp/psm-data" 
SUBFOLDER <- "sample"
```

Render the full report: `rmarkdown::render(here('pulceo-data-analytics.Rmd'), params = list(rootfolder = ROOTFOLDER, subfolder=SUBFOLDER))`

### Includes

| \# | Resource | Command |
|---|--------------|--------------------------------------------------------|
| 0 | PDA | `rmarkdown::render(here('pulceo-data-analytics.Rmd'), params = list(rootfolder = "/tmp/psm-data", subfolder="sample"))` |
| 1 | Topology | `rmarkdown::render(here('includes/topology.Rmd'))` |
| 2 | Events | `rmarkdown::render(here('includes/events.Rmd'))` |
| 3 | Resources | `rmarkdown::render(here('includes/resources.Rmd'))` |
| 4 | CPU Utilization  | `rmarkdown::render(here('includes/metrics/cpu-util.Rmd'))` |
| 5 | Memory Utilization  | `rmarkdown::render(here('includes/metrics/mem-util.Rmd'))`  |
| 6 | Storage Utilization  | `rmarkdown::render(here('includes/metrics/storage-util.Rmd'))` |
| 7 | Network Utilization  | `rmarkdown::render(here('includes/metrics/net-util.Rmd'))`  |
| 8 | Combined Utilization | `rmarkdown::render(here('includes/metrics/combined-util.Rmd'))` |
| 9 | Round-trip Time | `rmarkdown::render(here('includes/metrics/rtt.Rmd'))` |
| 10 | Bandwidth | `rmarkdown::render(here('includes/metrics/bw.Rmd'))` |
| 11 | Combined Link Quality | `rmarkdown::render(here('includes/metrics/combined-link-quality.Rmd'))` |
| 12 | Requests | `rmarkdown::render(here('includes/metrics/requests.Rmd'))` |
| 13 | Tasks | `rmarkdown::render(here('includes/metrics/tasks.Rmd'))` |

## Sample Reports

- SummerSoC2024-PROD-IDLE: `rmarkdown::render(here('pulceo-data-analytics.Rmd'), params = list(rootfolder = "/tmp/psm-data", subfolder="summersoc2024-prod-idle"))`
- SummerSoC2024-PROD-LOAD: `rmarkdown::render(here('pulceo-data-analytics.Rmd'), params = list(rootfolder = "/tmp/psm-data", subfolder="summersoc2024-prod-load"))`
- SummerSoC2025: `rmarkdown::render(here('pulceo-data-analytics.Rmd'), params = list(rootfolder = "/tmp/psm-data", subfolder="summersoc2025"))`
