source(here('includes/R/filter.R'))

tryCatch({
    EVENTS_RAW <- read.csv(paste(FOLDER_PFX_RAW, "EVENTS.csv", sep = "/"), skip = 3)
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
