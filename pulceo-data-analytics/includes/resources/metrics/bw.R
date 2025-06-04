source(here("includes/R/links.R"))
source(here("includes/R/filter.R"))
source(here("includes/resources/meta.R"))
# TCP
TCP_BW_RAW <- ReadAndFilterEndTime(here(paste("raw", SUBFOLDER, "TCP_BW.csv", sep = "/"), endTime))
TCP_BW <- TransfromNetworkMetricsMetadata(TCP_BW_RAW)
TCP_BW$iperfRole <- as.factor(TCP_BW$iperfRole)

# UDP
UDP_BW_RAW <- ReadAndFilterEndTime(here(paste("raw", SUBFOLDER, "UDP_BW.csv", sep = "/"), endTime))
UDP_BW <- TransfromNetworkMetricsMetadata(UDP_BW_RAW)
UDP_BW$iperfRole <- as.factor(UDP_BW$iperfRole)