source(here("includes/R/libraries.R"))

install_and_load("tidyverse")

TransfromNetworkMetricsMetadata <- function(df) {
  df$X_field <- as.factor(df$X_field)
  df$X_measurement <- as.factor(df$X_measurement)
  df$metricType <- as.factor(df$metricType)
  df$sourceHost <- as.factor(df$sourceHost)
  df$destinationHost <- as.factor(df$destinationHost)
  df$endTime <- as.POSIXct(df$endTime, format = "%Y-%m-%dT%H:%M:%OSZ")
  df$jobUUID <- as.factor(df$jobUUID)
  df <- merge(df, node_mapping, by.x = "sourceHost", by.y = "sourceHost")
  df <- merge(df, node_mapping_dest, by.x = "destinationHost", by.y = "destinationHost")
  return(df)
}

filterICMPRTT <- function(df, field) {
  return(df %>% filter(X_field == field))
}

HasLinks <- function(df) {
  nrow(df) > 0
}
