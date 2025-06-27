tryCatch({
    providers <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "PROVIDERS.json", sep = "/"))
}, error = function(e) {
    message("Error in read PROVIDERS.json: ", e$message)
    data.frame()
})

