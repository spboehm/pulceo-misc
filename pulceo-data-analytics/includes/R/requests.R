TransfromRequests <- function(df) {
  df$timestamp <- as.POSIXct(df$timestamp / 1e9, origin = "1970-01-01", tz = "CEST")
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
}
