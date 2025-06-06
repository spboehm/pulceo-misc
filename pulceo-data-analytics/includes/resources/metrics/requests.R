source(here("includes/R/requests.R"))
source(here("includes/resources/meta.R"))
REQUESTS_RAW <- read.csv(here(paste("raw", SUBFOLDER, "REQUESTS.csv", sep = "/")), skip = 3)
REQUESTS <- TransfromRequests(REQUESTS_RAW)
# TODO: Remove data.table
REQUESTS <- REQUESTS %>% filter(data.table::between(timestamp, as.POSIXct(start_timestamp, format = "%Y-%m-%dT%H:%M:%OSZ"), as.POSIXct(end_timestamp, format = "%Y-%m-%dT%H:%M:%OSZ")))
