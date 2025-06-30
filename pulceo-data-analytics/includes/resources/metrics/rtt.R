source(here("includes/R/links.R"))
source(here("includes/R/filter.R"))
source(here("includes/resources/meta.R"))

tryCatch({
    ICMP_RTT_RAW <- ReadAndFilterEndTime(paste(FOLDER_PFX_RAW, "ICMP_RTT.csv", sep = "/"), endTime)
    ICMP_RTT <- TransfromNetworkMetricsMetadata(ICMP_RTT_RAW)
}, error = function(e) {
    message("Error loading or transforming ICMP_RTT: ", e$message)
    STORAGE_UTIL <- data.frame()
}, finally = {
    ICMP_RTT_PRESENT <- nrow(ICMP_RTT) > 0
})