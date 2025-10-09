tryCatch({
    cpu_resources <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "CPUS.json", sep = "/"))
    if (length(cpu_resources) == 0) {
        cpu_resources <<- data.frame()
    }
}, error = function(e) {
    message("Error in read CPUS.json: ", e$message)
    cpu_resources <<- data.frame()
}, finally = {
    CPUS_PRESENT <- nrow(cpu_resources) > 0
})
