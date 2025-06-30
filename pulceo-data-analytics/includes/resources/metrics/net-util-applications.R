source(here("includes/resources/metrics/net-util.R"))

COMBINED_NET_UTIL_POD <- rbind(filterResourceUtilForNode(COMBINED_NET_UTIL, "rxBytes", "POD", "traefik|pulceo-node-agent|edge-iot-simulator"), filterResourceUtilForNode(COMBINED_NET_UTIL, "txBytes", "POD", "traefik|pulceo-node-agent|edge-iot-simulator"))

COMBINED_NET_UTIL_POD_PROCESSED <- COMBINED_NET_UTIL_POD %>%
  mutate(application = if_else(grepl("traefik", resourceName), "traefik",
    if_else(grepl("pulceo-node-agent", resourceName), "pulceo-node-agent",
      if_else(grepl("edge-iot-simulator", resourceName), "edge-iot-simulator", "")
    )
  )) %>%
  mutate(field = if_else(grepl("rxBytes", X_field), "Received (Rx)", if_else(grepl("txBytes", X_field), "Transmitted (Tx)", "")))