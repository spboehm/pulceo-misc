tryCatch({
    storage_resources <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "STORAGE.json", sep = "/"))
    if (length(storage_resources) == 0) {
        storage_resources <<- data.frame()
    }
}, error = function(e) {
    message("Error in read STORAGE.json: ", e$message)
    storage_resources <<- data.frame()
}, finally = {
    STORAGE_PRESENT <- nrow(storage_resources) > 0
})
