tryCatch({
    applications <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "APPLICATIONS.json", sep = "/"))
    if (length(applications) == 0) {
        applications <<- data.frame()
    }
}, error = function(e) {
    message("Error in read APPLICATIONS.json: ", e$message)
    applications <<- data.frame()
}, finally = {
    APPLICATIONS_PRESENT <- nrow(applications) > 0
})
