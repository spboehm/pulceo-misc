source(here("includes/resources/metrics/mem-util.R"))
source(here("includes/R/statistics.R"))

MEM_UTIL_PODS <- filterResourceUtilForNode(MEM_UTIL, "usageMemoryPercentage", "POD", "traefik|pulceo-node-agent|edge-iot-simulator")

MEM_UTIL_PODS_PROCESSED <- MEM_UTIL_PODS %>%
  group_by(nodeName) %>%
  arrange(timestamp, .by_group = TRUE) %>%
  mutate(id = row_number()) %>%
  mutate(application = if_else(grepl("traefik", resourceName), "traefik",
    if_else(grepl("pulceo-node-agent", resourceName), "pulceo-node-agent",
      if_else(grepl("edge-iot-simulator", resourceName), "edge-iot-simulator", "")
    )
  ))

MEM_UTIL_pods_summary <- CreateSummary(filterResourceUtilForNode(MEM_UTIL, "usageMemoryPercentage", "POD", "traefik"), "Pod")

MEM_UTIL_PODS_SUMMARY_BY_APP <- MEM_UTIL %>%
  filter(k8sResourceType == "POD", X_field == "usageMemoryPercentage") %>%
  group_by(nodeName, resourceName) %>%
  summarize(
    min = round(min(X_value), 3),
    avg = round(mean(X_value), 3),
    max = round(max(X_value), 3),
    median = round(median(X_value), 3),
    sd = round(sd(X_value), 3),
    .groups = "drop"
  )