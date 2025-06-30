tryCatch({
    applications <- jsonlite::fromJSON(here(paste(FOLDER_PFX_RAW, "APPLICATIONS.json", sep = "/")))
}, error = function(e) {
    message("Error in read APPLICATIONS.json: ", e$message)
    applications <- data.frame()
})
