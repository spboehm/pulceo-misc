source(here("includes/R/nodes.R"))
source(here("includes/R/filter.R"))
source(here("includes/resources/meta.R"))
NET_UTIL_RAW <- ReadAndFilterTimestamp(here(paste("raw", SUBFOLDER, "NET_UTIL.csv", sep = "/")), timestamp)
NET_UTIL <- TransfromNodeMetricsMetadata(NET_UTIL_RAW)
NET_UTIL_PRESENT <- nrow(NET_UTIL) > 0
