tryCatch({
    nodes <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "NODES.json", sep = "/"))
    if (length(nodes) == 0) {
        nodes <<- data.frame()
    }
}, error = function(e) {
    message("Error in read NODES.json: ", e$message)
    nodes <<- data.frame()
}, finally = {
    NODES_PRESENT <- nrow(nodes) > 0
})
