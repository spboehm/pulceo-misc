CreateSummary <- function(df, resource) {
  df <- df %>%
    group_by(nodeName) %>%
    summarize(
      min = round(min(X_value), 3),
      avg = round(mean(X_value), 3),
      max = round(max(X_value), 3),
      median = round(median(X_value), 3),
      sd = round(sd(X_value), 3), .groups = "drop"
    )
  names(df) <- c(resource, "Min", "Mean", "Max", "Med", "SD")
  return(df)
}

CreateSummaryForStorage <- function(df, resource) {
  df <- df %>%
    group_by(resourceName) %>%
    summarize(
      min = round(min(X_value), 3),
      avg = round(mean(X_value), 3),
      max = round(max(X_value), 3),
      median = round(median(X_value), 3),
      sd = round(sd(X_value), 3), .groups = "drop"
    )
  names(df) <- c(resource, "Min", "Mean", "Max", "Med", "SD")
  return(df)
}

CreateSummaryForNetUtil <- function(df, resource) {
  df <- df %>%
    group_by(nodeName, X_field) %>%
    summarize(max = round(max(X_value_final / 1024 / 1024 / 1024), 3), .groups = "drop")
  return(df)
}