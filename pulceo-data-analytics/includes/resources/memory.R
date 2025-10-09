tryCatch({
    memory_resources <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "MEMORY.json", sep = "/"))
    if (length(memory_resources) == 0) {
        memory_resources <<- data.frame()
    }
}, error = function(e) {
    message("Error in read MEMORY.json: ", e$message)
    memory_resources <<- data.frame()
}, finally = {
    MEMORY_PRESENT <- nrow(memory_resources) > 0
})
