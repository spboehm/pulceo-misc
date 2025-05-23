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

filterResourceUtilForNode <- function(df, field, resourceType, resource) {
  return(df %>% filter(X_field == field) %>%
    filter(k8sResourceType == resourceType) %>%
    filter(grepl(resource, resourceName)))
}

HasNodes <- function(df) {
  nrow(df %>% filter(k8sResourceType == "NODE")) > 0
}
