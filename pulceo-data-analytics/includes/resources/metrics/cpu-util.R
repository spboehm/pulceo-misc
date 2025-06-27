source(here("includes/R/nodes.R"))
source(here("includes/R/filter.R"))
source(here("includes/resources/meta.R"))
CPU_UTIL_RAW <- ReadAndFilterTimestamp(paste(FOLDER_PFX_RAW, "CPU_UTIL.csv", sep = "/"), timestamp)
CPU_UTIL <- TransfromNodeMetricsMetadata(CPU_UTIL_RAW)
CPU_UTIL_PRESENT <- nrow(CPU_UTIL) > 0
