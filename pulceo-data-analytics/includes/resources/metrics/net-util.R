source(here("includes/R/nodes.R"))
source(here("includes/R/filter.R"))
source(here("includes/resources/meta.R"))
NET_UTIL_RAW <- ReadAndFilterTimestamp(here(paste("raw", SUBFOLDER, "NET_UTIL.csv", sep = "/")), timestamp)
NET_UTIL <- TransfromNodeMetricsMetadata(NET_UTIL_RAW)

# TODO: HasNodes, HasApplications?
# TODO: Remove?
INITIAL_TX_RX <- NET_UTIL %>%
  group_by(nodeName, X_field, k8sResourceType, resourceName) %>%
  slice(which.min(timestamp)) %>%
  select(nodeName, sourceHost, k8sResourceType, resourceName, X_field, X_value) %>%
  rename(X_value_initial = X_value)

COMBINED_NET_UTIL <- left_join(NET_UTIL, INITIAL_TX_RX, join_by(nodeName, sourceHost, k8sResourceType, resourceName, X_field))
COMBINED_NET_UTIL$X_value_final <- ((COMBINED_NET_UTIL$X_value - COMBINED_NET_UTIL$X_value_initial))

COMBINED_NET_UTIL_POD <- rbind(filterResourceUtilForNode(COMBINED_NET_UTIL, "rxBytes", "POD", "traefik|pulceo-node-agent|edge-iot-simulator"), filterResourceUtilForNode(COMBINED_NET_UTIL, "txBytes", "POD", "traefik|pulceo-node-agent|edge-iot-simulator"))

COMBINED_NET_UTIL_POD_PROCESSED <- COMBINED_NET_UTIL_POD %>%
  mutate(application = if_else(grepl("traefik", resourceName), "traefik",
    if_else(grepl("pulceo-node-agent", resourceName), "pulceo-node-agent",
      if_else(grepl("edge-iot-simulator", resourceName), "edge-iot-simulator", "")
    )
  )) %>%
  mutate(field = if_else(grepl("rxBytes", X_field), "Received (Rx)", if_else(grepl("txBytes", X_field), "Transmitted (Tx)", "")))
