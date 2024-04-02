# transformations
TransfromNodeMetricsMetadata <- function (df) {
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

CreateSummary <- function(df, resource) {
  df <- df %>% 
    group_by(nodeName) %>% 
    summarize(min = round(min(X_value), 3),
              avg = round(mean(X_value), 3),
              max = round(max(X_value), 3),
              median = round(median(X_value), 3),
              std = round(sd(X_value), 3))
  names(df) <- c(resource, "MIN", "AVG", "MAX", "MEDIAN", "SD")
  return(df)
}

CreateSummaryForNetUtil <- function(df, resource) {
  df <- df %>% 
    group_by(nodeName, X_field) %>% 
    summarize(max = round(max(X_value_final / 1024 / 1024 / 1024), 3))
  return(df)
}

# latex generation
SaveLatexTable <- function(summary, caption, label, filename) {
  latex_table <- kbl(summary, "latex", escape = FALSE, caption = caption, booktabs = FALSE, linesep="", vline="", label = label)
  save_kable(latex_table, paste("latex", SUBFOLDER, filename, sep = "/"))
}

# resources
node_mapping <- Reduce(rbind, lapply(NODES_RAW, function (x) {
  return(c(x$hostname, x$node$name))
}))

node_mapping <- as.data.frame(node_mapping)
names(node_mapping) <- c("sourceHost", "nodeName")

node_mapping_dest <- node_mapping
names(node_mapping_dest) <- c("destinationHost", "nodeNameDest")
