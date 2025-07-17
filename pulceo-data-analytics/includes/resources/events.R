source(here('includes/R/filter.R'))

EVENTS_FILE_PATH <- paste(FOLDER_PFX_RAW, "EVENTS.csv", sep = "/")

if (!file.exists(EVENTS_FILE_PATH)) {
    EVENTS_FILE_PATH <- paste(FOLDER_PFX_RAW, "EVENT.csv", sep = "/")
}

tryCatch({
    EVENTS_RAW <- read.csv(EVENTS_FILE_PATH, skip = 3)
}, error = function(e) {
    message("Error in read EVENTS.csv: ", e$message)
    EVENTS_RAW <<- data.frame()
}, finally = {
    EVENTS_PRESENT <- nrow(EVENTS_RAW) > 0
})

if (EVENTS_PRESENT) {
    events <- FilterInfluxDbCsv(EVENTS_RAW)
    events_summary <- ProcessInfluxDbDfSummary(events)
}
