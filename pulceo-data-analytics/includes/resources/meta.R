source(here("includes/R/libraries.R"))
source(here("includes/R/directories.R"))

install_and_load("data.table")
install_and_load("rjson")

# meta file for orchestration
dframe <- read.table(
  file = here(paste(FOLDER_PFX_RAW, "META.txt", sep = "/")), header = FALSE,
  sep = "=", col.names = c("Key", "Value")
)
dtable <- data.table(dframe, key = "Key")
node_scale_fills <- str_split(dtable["NODE_SCALES"]$Value, pattern = ",")[[1]]
node_scale_fills_ext <- str_split(dtable["NODE_SCALES_EXT"]$Value, pattern = ",")[[1]]
start_timestamp <- dtable["START_TIMESTAMP"]$Value
end_timestamp <- dtable["END_TIMESTAMP"]$Value
nodes <- dtable["NODES"]$Value

# TODO: remove NODE_RAW
NODES_RAW <- rjson::fromJSON(file = here(paste("raw", SUBFOLDER, "NODES.json", sep = "/")))

# node mapping
node_mapping <- Reduce(rbind, lapply(NODES_RAW, function(x) {
  return(c(x$hostname, x$node$name))
}))

node_mapping <- as.data.frame(node_mapping)
names(node_mapping) <- c("sourceHost", "nodeName")

node_mapping_dest <- node_mapping
names(node_mapping_dest) <- c("destinationHost", "nodeNameDest")

scale <- function(x, na.rm = FALSE) (format(round(x, digits = 2), nsmall = 2))
