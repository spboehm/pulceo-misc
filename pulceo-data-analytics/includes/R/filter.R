source(here("includes/R/libraries.R"))

install_and_load("tidyverse")

# TODO: add start_timestamp and end_timestamp to function
ReadAndFilterTimestamp <- function(file, timestamp) {
  tryCatch({
    return(read.csv(file, skip = 3) %>%
      filter(between(timestamp, start_timestamp, end_timestamp), grepl(paste0(nodes, "|pna-k8s-node"), resourceName)))
  }, error = function(e) {
    message("Error in ReadAndFilterTimestamp: ", e$message)
    return(data.frame())
  })
}

ReadAndFilterEndTime <- function(file, endTime) {
  tryCatch({
    return(read.csv(file, skip = 3) %>%
      filter(between(endTime, start_timestamp, end_timestamp)))
  }, error = function(e) {
    message("Error in ReadAndFilterEndTime: ", e$message)
    return(data.frame())
  })
}

FilterInfluxDbCsv <- function(df) {
  df %>% select(-"X", -"result", -"X_start", -"X_stop", -"X_time", -"X_field")
}

ProcessInfluxDbDfSummary <- function(df) {
  df %>%
    group_by(X_measurement, eventType) %>%
    summarise(
      count = n(),
      min_timestamp = min(timestamp, na.rm = TRUE),
      max_timestamp = max(timestamp, na.rm = TRUE),
      .groups = "drop"
    )
}