tryCatch({
    links <- jsonlite::fromJSON(here(paste(FOLDER_PFX_RAW, "LINKS.json", sep = "/")))
}, error = function(e) {
    message("Error in read LINKS.json: ", e$message)
    links <- data.frame()
})
