tryCatch({
    memory_resources <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "MEMORY.json", sep = "/"))
}, error = function(e) {
    message("Error in read MEMORY.json: ", e$message)
    memory_resources <- data.frame()
})
