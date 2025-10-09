source(here("includes/resources/metrics/cpu-util.R"))
source(here("includes/R/statistics.R"))

CPU_UTIL_PODS <- filterResourceUtilForNode(CPU_UTIL, "usageCPUPercentage", "POD", "traefik|pulceo-node-agent|edge-iot-simulator")

CPU_UTIL_PODS_PROCESSED <- CPU_UTIL_PODS %>%
  group_by(nodeName) %>%
  arrange(timestamp, .by_group = TRUE) %>%
  mutate(id = row_number()) %>%
  mutate(application = if_else(grepl("traefik", resourceName), "traefik",
    if_else(grepl("pulceo-node-agent", resourceName), "pulceo-node-agent",
      if_else(grepl("edge-iot-simulator", resourceName), "edge-iot-simulator", "")
    )
  ))

CPU_UTIL_pods_summary <- CreateSummary(filterResourceUtilForNode(CPU_UTIL, "usageCPUPercentage", "POD", "edge-iot-simulator"), "Pod")

CPU_UTIL_PODS_SUMMARY_BY_APP <- CPU_UTIL %>%
  filter(k8sResourceType == "POD", X_field == "usageCPUPercentage") %>%
  group_by(nodeName, resourceName) %>%
  summarize(
    min = round(min(X_value), 3),
    avg = round(mean(X_value), 3),
    max = round(max(X_value), 3),
    median = round(median(X_value), 3),
    sd = round(sd(X_value), 3), 
    .groups = "drop"
  )
