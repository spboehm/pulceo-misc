TransfromNodeMetricsMetadata <- function(df) {
  df$X_field <- as.factor(df$X_field)
  df$k8sResourceType <- as.factor(df$k8sResourceType)
  df$resourceName <- as.factor(df$resourceName)
  df$X_measurement <- as.factor(df$X_measurement)
  df$metricType <- as.factor(df$metricType)
  df$sourceHost <- as.factor(df$sourceHost)
  df$timestamp <- as.POSIXct(df$timestamp, format = "%Y-%m-%dT%H:%M:%OSZ")
  df <- merge(df, node_mapping, by = "sourceHost")
  return(df)
}
