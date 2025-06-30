tryCatch({
    nodes <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "NODES.json", sep = "/"))
}, error = function(e) {
    message("Error in read NODES.json: ", e$message)
    nodes <- data.frame()
})
