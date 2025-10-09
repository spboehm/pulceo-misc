HasApplications <- function(df) {
  nrow(df %>% filter(k8sResourceType == "POD")) > 0
}
