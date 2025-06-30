source(here("includes/R/nodes.R"))
source(here("includes/R/filter.R"))
source(here("includes/resources/meta.R"))
STORAGE_UTIL_RAW <- ReadAndFilterTimestamp(paste(FOLDER_PFX_RAW, "STORAGE_UTIL.csv", sep = "/"), timestamp)
STORAGE_UTIL <- TransfromNodeMetricsMetadata(STORAGE_UTIL_RAW)
STORAGE_UTIL_PRESENT <- nrow(STORAGE_UTIL) > 0
