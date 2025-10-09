tryCatch({
    links <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "LINKS.json", sep = "/"))
    if (length(links) == 0) {
        links <<- data.frame()
    }
}, error = function(e) {
    message("Error in read LINKS.json: ", e$message)
    links <<- data.frame()
}, finally = {
    LINKS_PRESENT <- nrow(links) > 0
})
