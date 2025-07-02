source(here("includes/R/libraries.R"))
source(here("includes/R/directories.R"))

install_and_load("data.table")
install_and_load("tidyverse")
install_and_load("rjson")

# meta file for orchestration
dframe <- read.table(
  file = paste(FOLDER_PFX_RAW, "META.txt", sep = "/"), header = FALSE,
  sep = "=", col.names = c("Key", "Value")
)
dtable <- data.table(dframe, key = "Key")
node_scale_fills <- strsplit(dtable["NODE_SCALES"]$Value, ",")[[1]]
node_scale_fills_ext <- strsplit(dtable["NODE_SCALES_EXT"]$Value, ",")[[1]]
start_timestamp <- dtable["START_TIMESTAMP"]$Value
end_timestamp <- dtable["END_TIMESTAMP"]$Value
nodes <- dtable["NODES"]$Value

# TODO: remove NODE_RAW with rson
# NODES_RAW <- rjson::fromJSON(file = here(paste(FOLDER_PFX_RAW, "NODES.json", sep = "/")))
NODES_RAW <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "NODES.json", sep = "/"))

node_mapping <- NODES_RAW %>%
  unnest(cols = c(node)) %>%
  select(hostname, name) %>%
  rename(sourceHost = hostname, nodeName = name)

node_mapping_dest <- NODES_RAW %>%
  unnest(cols = c(node)) %>%
  select(hostname, name) %>%
  rename(destinationHost = hostname, nodeNameDest = name)

ART_PLOT_WIDTH <- as.numeric(ifelse(is.na(dtable["ART_PLOT_WIDTH"]$Value), 8, dtable["ART_PLOT_WIDTH"]$Value))
ART_PLOT_HEIGHT <- as.numeric(ifelse(is.na(dtable["ART_PLOT_HEIGHT"]$Value), 3, dtable["ART_PLOT_HEIGHT"]$Value))
ART_SHORT_NAMES <- as.logical(ifelse(is.na(dtable["ART_SHORT_NAMES"]$Value), FALSE, dtable["ART_SHORT_NAMES"]$Value))

scale <- function(x, na.rm = FALSE) (format(round(x, digits = 2), nsmall = 2))
