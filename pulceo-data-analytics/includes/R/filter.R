source(here("includes/R/libraries.R"))

install_and_load("tidyverse")

# TODO: add start_timestamp and end_timestamp to function
ReadAndFilterTimestamp <- function(file, timestamp) {
  tryCatch({
    return(ReadInfluxDbCsv(file) %>%
      filter(between(timestamp, start_timestamp, end_timestamp), grepl(paste0(NODE_NAMES_CONCAT, "|pna-k8s-node"), resourceName)))
  }, error = function(e) {
    message("Error in ReadAndFilterTimestamp: ", e$message)
    return(data.frame())
  })
}

ReadAndFilterEndTime <- function(file, endTime) {
  tryCatch({
    return(ReadInfluxDbCsv(file) %>%
      filter(between(endTime, start_timestamp, end_timestamp)))
  }, error = function(e) {
    message("Error in ReadAndFilterEndTime: ", e$message)
    return(data.frame())
  })
}

ReadInfluxDbCsv <- function(file) {
  if (grepl("#", readLines(file, n = 1), fixed = TRUE)) {
      # indicates old version with header of 3
      df <- read.csv(file, skip = 3)
  } else {
      # indicated new version without the header
      df <- read.csv(file, skip = 0)
  }
  return(df)
}

FilterInfluxDbCsv <- function(df) {
  df %>% select(-any_of(c("X", "result", "X_start", "X_stop", "X_time", "X_field")))
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