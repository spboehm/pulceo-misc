# Pulceo-Data-Analytics (Renderer)

## How to run

```R
library(plumber)
pr <- plumber::plumb('pda.R'); pr$run(host='0.0.0.0', port=8181)
```

## How to build