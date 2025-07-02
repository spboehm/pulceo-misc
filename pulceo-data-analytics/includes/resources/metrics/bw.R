source(here("includes/R/links.R"))
source(here("includes/R/filter.R"))
source(here("includes/resources/meta.R"))

# TCP
tryCatch({
  TCP_BW_RAW <- ReadAndFilterEndTime(paste(FOLDER_PFX_RAW, "TCP_BW.csv", sep = "/"), endTime)
  TCP_BW <- TransfromNetworkMetricsMetadata(TCP_BW_RAW)
}, error = function(e) {
    message("Error loading or transforming TCP_BW: ", e$message)
    TCP_BW <<- data.frame()
}, finally = {
  TCP_BW_PRESENT <- nrow(TCP_BW)
})

if (TCP_BW_PRESENT) {
  TCP_BW$iperfRole <- as.factor(TCP_BW$iperfRole)
  TCP_BW_SUMMARY <- filterBW(TCP_BW, "bitrate", "SENDER")

  # build upload df
  TCP_BW_SUMMARY <- TCP_BW_SUMMARY %>%
    group_by(nodeName, nodeNameDest) %>%
    summarise(
      min = round(min(X_value), 3),
      avg = round(mean(X_value), 3),
      max = round(max(X_value), 3),
      median = round(median(X_value), 3),
      std = round(sd(X_value), 3), .groups = "drop"
    ) %>%
    mutate(across(where(is.numeric), \(x) round(x, 3)))

  names(TCP_BW_SUMMARY) <- c("Source", "Destination", "Min", "Mean", "Max", "Med", "SD")
}

# UDP
tryCatch({
  UDP_BW_RAW <- ReadAndFilterEndTime(paste(FOLDER_PFX_RAW, "UDP_BW.csv", sep = "/"), endTime)
  UDP_BW <- TransfromNetworkMetricsMetadata(UDP_BW_RAW)
}, error = function(e) {
    message("Error loading or transforming UDP_BW: ", e$message)
    UDP_BW <<- data.frame()
}, finally = {
  UDP_BW_PRESENT <- nrow(UDP_BW)
})

if (UDP_BW_PRESENT) {
  UDP_BW$iperfRole <- as.factor(UDP_BW$iperfRole)
  UDP_BW <- filterBW(UDP_BW, c("bitrate", "jitter", "lostDatagrams", "totalDatagrams"), "RECEIVER")

  UDP_BW_PACKAGE_LOSS_SUMMARY <- UDP_BW %>%
    select(endTime, nodeName, nodeNameDest, metricUUID, X_field, X_value) %>%
    filter(X_field %in% c("lostDatagrams", "totalDatagrams")) %>%
    pivot_wider(names_from = X_field, values_from = X_value) %>%
    mutate(lostDatagramsPercentage = (lostDatagrams / totalDatagrams) * 100) %>%
    group_by(nodeName, nodeNameDest) %>%
    summarise(
      min = round(min(lostDatagramsPercentage), 3),
      avg = round(mean(lostDatagramsPercentage), 3),
      max = round(max(lostDatagramsPercentage), 3),
      median = round(median(lostDatagramsPercentage), 3),
      std = round(sd(lostDatagramsPercentage), 3), .groups = "drop"
    )

  UDP_BW_SUMMARY <- UDP_BW %>%
    select(endTime, nodeName, nodeNameDest, metricUUID, X_field, X_value) %>%
    filter(X_field %in% c("bitrate")) %>%
    group_by(nodeName, nodeNameDest, X_field) %>%
    summarise(
      min = round(min(X_value), 3),
      avg = round(mean(X_value), 3),
      max = round(max(X_value), 3),
      median = round(median(X_value), 3),
      std = round(sd(X_value), 3), .groups = "drop"
    ) %>%
    select(c(-X_field)) %>%
    mutate(across(where(is.numeric), \(x) round(x, 3)))
  names(UDP_BW_SUMMARY) <- c("Source", "Destination", "Min", "Mean", "Max", "Med", "SD")

  UDP_BW_SUMMARY_JITTER <- UDP_BW %>%
    select(endTime, nodeName, nodeNameDest, metricUUID, X_field, X_value) %>%
    filter(X_field %in% c("jitter")) %>%
    group_by(nodeName, nodeNameDest, X_field) %>%
    summarise(
      min = round(min(X_value), 3),
      mean = round(mean(X_value), 3),
      max = round(max(X_value), 3),
      median = round(median(X_value), 3),
      std = round(sd(X_value), 3), .groups = "drop"
    ) %>%
    select(c(-X_field)) %>%
    rename(Source = nodeName, Destination = nodeNameDest)


  names(UDP_BW_SUMMARY_JITTER) <- c("$v_1$", "$v_2$", "Min", "Mean", "Max", "Med", "SD")

  UDP_BW_PACKAGE_LOSS <- UDP_BW %>%
    select(endTime, nodeName, nodeNameDest, metricUUID, X_field, X_value) %>%
    filter(X_field %in% c("lostDatagrams", "totalDatagrams")) %>%
    pivot_wider(names_from = X_field, values_from = X_value) %>%
    mutate(lostDatagramsPercentage = (lostDatagrams / totalDatagrams) * 100) %>%
    group_by(nodeName, nodeNameDest) %>%
    summarise(
      min = round(min(lostDatagramsPercentage), 3),
      mean = round(mean(lostDatagramsPercentage), 3),
      max = round(max(lostDatagramsPercentage), 3),
      median = round(median(lostDatagramsPercentage), 3),
      std = round(sd(lostDatagramsPercentage), 3), .groups = "drop"
    ) %>%
    rename(Source = nodeName, Destination = nodeNameDest)
  names(UDP_BW_PACKAGE_LOSS) <- c("$v_1$", "$v_2$", "Min", "Mean", "Max", "Med", "SD")
}
