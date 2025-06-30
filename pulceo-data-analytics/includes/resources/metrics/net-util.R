source(here("includes/R/nodes.R"))
source(here("includes/R/filter.R"))
source(here("includes/resources/meta.R"))

tryCatch({
    NET_UTIL_RAW <- ReadAndFilterTimestamp(paste(FOLDER_PFX_RAW, "NET_UTIL.csv", sep = "/"), timestamp)
    NET_UTIL <- TransfromNodeMetricsMetadata(NET_UTIL_RAW)
}, error = function(e) {
    message("Error loading or transforming NET_UTIL: ", e$message)
    NET_UTIL <- data.frame()
}, finally = {
    NET_UTIL_PRESENT <- nrow(NET_UTIL) > 0
})

if (NET_UTIL_PRESENT) {
    INITIAL_TX_RX <- NET_UTIL %>%
        group_by(nodeName, X_field, k8sResourceType, resourceName) %>%
        slice(which.min(timestamp)) %>%
        select(nodeName, sourceHost, k8sResourceType, resourceName, X_field, X_value) %>%
        rename(X_value_initial = X_value)

    COMBINED_NET_UTIL <- left_join(NET_UTIL, INITIAL_TX_RX, join_by(nodeName, sourceHost, k8sResourceType, resourceName, X_field))
    COMBINED_NET_UTIL$X_value_final <- ((COMBINED_NET_UTIL$X_value - COMBINED_NET_UTIL$X_value_initial))
}
