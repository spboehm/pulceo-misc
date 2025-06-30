source(here("includes/R/requests.R"))
source(here("includes/resources/meta.R"))
REQUESTS_RAW <- read.csv(paste(FOLDER_PFX_RAW, "REQUESTS.csv", sep = "/"), skip = 3)
REQUESTS <- TransfromRequests(REQUESTS_RAW)
# TODO: Remove data.table and do with ReadAndFilterTimestamp
REQUESTS <- REQUESTS %>% filter(data.table::between(timestamp, as.POSIXct(start_timestamp, format = "%Y-%m-%dT%H:%M:%OSZ"), as.POSIXct(end_timestamp, format = "%Y-%m-%dT%H:%M:%OSZ")))
