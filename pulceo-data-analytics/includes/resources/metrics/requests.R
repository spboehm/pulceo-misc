source(here("includes/R/requests.R"))
source(here("includes/resources/meta.R"))

REQUESTS_FILE_PATH <- paste(FOLDER_PFX_RAW, "REQUESTS.csv", sep = "/")

if (!file.exists(REQUESTS_FILE_PATH)) {
    REQUESTS_FILE_PATH <- paste(FOLDER_PFX_RAW, "REQUEST.csv", sep = "/")
}

tryCatch({
    REQUESTS_RAW <- read.csv(REQUESTS_FILE_PATH, skip = 3)
    REQUESTS <- TransfromRequests(REQUESTS_RAW)
}, error = function(e) {
    message("Error loading or transforming REQUESTS: ", e$message)
    REQUESTS <<- data.frame()
}, finally = {
    REQUESTS_PRESENT <- nrow(REQUESTS) > 0
})
