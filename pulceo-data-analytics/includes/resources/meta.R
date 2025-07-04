source(here("includes/R/libraries.R"))
source(here("includes/R/directories.R"))

install_and_load("tidyverse")

tryCatch({
  meta <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "META.json", sep = "/"))
}, error = function(e) {
  message("Error in reading META.json: ", e$message)
  stop("Failed to load META.json")
})

node_scale_fills <- meta$NODE_SCALES
node_scale_fills_ext <- meta$NODE_SCALES_EXT
start_timestamp <- meta$START_TIMESTAMP
end_timestamp <- meta$END_TIMESTAMP
nodes <- meta$NODES

tryCatch({
  NODES_RAW <- jsonlite::fromJSON(paste(FOLDER_PFX_RAW, "NODES.json", sep = "/"))
}, error = function(e) {
  message("Error in reading NODES.json: ", e$message)
  stop("Failed to load NODES.json")
})

node_mapping <- NODES_RAW %>%
  unnest(cols = c(node)) %>%
  select(hostname, name) %>%
  rename(sourceHost = hostname, nodeName = name)

node_mapping_dest <- NODES_RAW %>%
  unnest(cols = c(node)) %>%
  select(hostname, name) %>%
  rename(destinationHost = hostname, nodeNameDest = name)

ART_PLOT_WIDTH <- as.numeric(ifelse(is.null(meta$ART_PLOT_WIDTH), 8, meta$ART_PLOT_WIDTH))
ART_PLOT_HEIGHT <- as.numeric(ifelse(is.null(meta$ART_PLOT_HEIGHT), 3, meta$ART_PLOT_HEIGHT))
ART_SHORT_NAMES <- as.logical(ifelse(is.null(meta$ART_SHORT_NAMES), FALSE, meta$ART_SHORT_NAMES))

scale <- function(x, na.rm = FALSE) (format(round(x, digits = 2), nsmall = 2))
