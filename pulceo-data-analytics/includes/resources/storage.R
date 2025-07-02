tryCatch({
    storage_resources <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "STORAGE.json", sep = "/"))   
}, error = function(e) {
    message("Error in read STORAGE.json: ", e$message)
    storage_resources <<- data.frame()
})
