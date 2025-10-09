source(here("includes/R/nodes.R"))
source(here("includes/R/filter.R"))
source(here("includes/resources/meta.R"))

tryCatch({
    STORAGE_UTIL_RAW <- ReadAndFilterTimestamp(paste(FOLDER_PFX_RAW, "STORAGE_UTIL.csv", sep = "/"), timestamp)
    STORAGE_UTIL <- TransfromNodeMetricsMetadata(STORAGE_UTIL_RAW)
}, error = function(e) {
    message("Error loading or transforming STORAGE_UTIL: ", e$message)
    STORAGE_UTIL <<- data.frame()
}, finally = {
    STORAGE_UTIL_PRESENT <- nrow(STORAGE_UTIL) > 0
})
