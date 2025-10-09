source(here("includes/R/libraries.R"))

install_and_load("tidyverse")

TransfromRequests <- function(df, requestType = NULL) {

  if(HasReqRtt(df)) {
    df$timestamp <- as.POSIXct(df$timestamp / 1e9, origin = "1970-01-01", tz = "UTC")
    df$timestamp <- as.POSIXct(df$timestamp, format = "%Y-%m-%dT%H:%M:%OSZ")
    df$X_field <- as.factor(df$X_field)
    df$X_measurement <- as.factor(df$X_measurement)
    df$sourceHost <- as.factor(df$sourceHost)
    df$destinationHost <- gsub("https://|:80", "", df$destinationHost)
    df <- merge(df, node_mapping, by.x = "destinationHost", by.y = "sourceHost")
    df$sourceHost <- gsub("-edge-iot-simulator", "-eis", df$sourceHost)
    names(df)[names(df) == "nodeName"] <- "destHost"
    df$destHost <- paste0(df$destHost, "-eis", "")
    return(df)
  } else if (HasTaskRtt(df)) {
    df$timestamp <- as.POSIXct(df$timestamp / 1e9, origin = "1970-01-01", tz = "UTC")
    df$timestamp <- as.POSIXct(df$timestamp, format = "%Y-%m-%dT%H:%M:%OSZ")
    df$X_field <- as.factor(df$X_field)
    df$X_measurement <- as.factor(df$X_measurement)
    df$sourceHost <- as.factor(df$sourceHost)
    return(df)
  } else {
     message("Error in transforming requests")
    return(data.frame())
  }
}

HasReqRtt <- function(df) {
  nrow(df %>% filter(requestType == "req_rtt")) > 0
}

HasTaskRtt <- function(df) {
  nrow(df %>% filter(requestType == "task_rtt")) > 0
}
