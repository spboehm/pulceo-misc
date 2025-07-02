source(here("includes/R/nodes.R"))
source(here("includes/R/filter.R"))
source(here("includes/resources/meta.R"))

tryCatch({
    MEM_UTIL_RAW <- ReadAndFilterTimestamp(paste(FOLDER_PFX_RAW, "MEM_UTIL.csv", sep = "/"), timestamp)
    MEM_UTIL <- TransfromNodeMetricsMetadata(MEM_UTIL_RAW)
}, error = function(e) {
    message("Error loading or transforming MEM_UTIL: ", e$message)
    MEM_UTIL <<- data.frame()
}, finally = {
    MEM_UTIL_PRESENT <- nrow(MEM_UTIL) > 0
})
