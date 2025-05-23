source(here("includes/R/libraries.R"))

install_and_load("tidyverse")

# TODO: add start_timestamp and end_timestamp to function
ReadAndFilterTimestamp <- function(file, timestamp) {
  return(read.csv(file, skip = 3) %>%
    filter(between(timestamp, start_timestamp, end_timestamp), grepl(paste0(nodes, "|pna-k8s-node"), resourceName)))
}

ReadAndFilterEndTime <- function(file, endTime) {
  return(read.csv(file, skip = 3) %>%
    filter(between(endTime, start_timestamp, end_timestamp)))
}
