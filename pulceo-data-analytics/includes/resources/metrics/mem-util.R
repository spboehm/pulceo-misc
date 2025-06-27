source(here("includes/R/nodes.R"))
source(here("includes/R/filter.R"))
source(here("includes/resources/meta.R"))
MEM_UTIL_RAW <- ReadAndFilterTimestamp(here(paste("raw", SUBFOLDER, "MEM_UTIL.csv", sep = "/")), timestamp)
MEM_UTIL <- TransfromNodeMetricsMetadata(MEM_UTIL_RAW)
MEM_UTIL_PRESENT <- nrow(MEM_UTIL) > 0
