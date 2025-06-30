source(here("includes/R/nodes.R"))
source(here("includes/R/filter.R"))
source(here("includes/resources/meta.R"))

tryCatch({
    CPU_UTIL_RAW <- ReadAndFilterTimestamp(paste(FOLDER_PFX_RAW, "CPU_UTIL.csv", sep = "/"), timestamp)
    CPU_UTIL <- TransfromNodeMetricsMetadata(CPU_UTIL_RAW)
}, error = function(e) {
    message("Error loading or transforming CPU_UTIL: ", e$message)
    CPU_UTIL <- data.frame()
}, finally = {
    CPU_UTIL_PRESENT <- nrow(CPU_UTIL) > 0
})
