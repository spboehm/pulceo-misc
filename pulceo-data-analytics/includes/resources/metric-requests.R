tryCatch({
    metric_requests <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "METRIC_REQUESTS.json", sep = "/"))
}, error = function(e) {
    message("Error in read METRIC_REQUESTS.json: ", e$message)
    metric_requests <<- data.frame()
})
