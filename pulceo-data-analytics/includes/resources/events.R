tryCatch({
    events <- read.csv(paste(FOLDER_PFX_RAW, "EVENTS.csv", sep = "/"), skip = 3)
}, error = function(e) {
    message("Error in read EVENTS.csv: ", e$message)
    events <<- data.frame()
})
