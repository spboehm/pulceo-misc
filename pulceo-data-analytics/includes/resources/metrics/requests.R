source(here("includes/R/requests.R"))
source(here("includes/resources/meta.R"))

tryCatch({
    REQUESTS_RAW <- read.csv(paste(FOLDER_PFX_RAW, "REQUESTS.csv", sep = "/"), skip = 3)
    REQUESTS <- TransfromRequests(REQUESTS_RAW)
}, error = function(e) {
    message("Error loading or transforming REQUESTS: ", e$message)
    REQUESTS <- data.frame()
}, finally = {
    REQUESTS_PRESENT <- nrow(REQUESTS) > 0
})
