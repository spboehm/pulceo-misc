tryCatch({
    metric_requests <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "METRIC_REQUESTS.json", sep = "/"))
    if (length(metric_requests) == 0) {
        metric_requests <<- data.frame()
    }
}, error = function(e) {
    message("Error in read METRIC_REQUESTS.json: ", e$message)
    metric_requests <<- data.frame()
}, finally = {
    METRIC_REQUESTS_PRESENT <- nrow(metric_requests) > 0
})
