source(here("includes/R/links.R"))
source(here("includes/R/filter.R"))
source(here("includes/resources/meta.R"))
ICMP_RTT_RAW <- ReadAndFilterEndTime(here(paste("raw", SUBFOLDER, "ICMP_RTT.csv", sep = "/")), endTime)
ICMP_RTT <- TransfromNetworkMetricsMetadata(ICMP_RTT_RAW)

ICMP_RTT_SUMMARY <- filterICMPRTT(ICMP_RTT, "rttAvg")

ICMP_RTT_SUMMARY <- ICMP_RTT_SUMMARY %>%
  group_by(nodeName, nodeNameDest) %>%
  summarise(
    min = round(min(X_value), 3),
    avg = round(mean(X_value), 3),
    max = round(max(X_value), 3),
    median = round(median(X_value), 3),
    sd = round(sd(X_value), 3), .groups = "drop"
  ) %>%
  mutate_if(is.numeric, scale, na.rm = TRUE)
names(ICMP_RTT_SUMMARY) <- c("$v_1$", "$v_2$", "Min", "Mean", "Max", "Med", "SD")
