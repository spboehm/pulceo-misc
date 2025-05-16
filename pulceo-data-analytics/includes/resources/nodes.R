nodes <- jsonlite::fromJSON(here(paste(FOLDER_PFX_RAW, "NODES.json", sep = "/")))
cpu_resources <- jsonlite::fromJSON(here(paste("raw", SUBFOLDER, "CPUS.json", sep = "/")))
memory_resources <- jsonlite::fromJSON(here(paste("raw", SUBFOLDER, "MEMORY.json", sep = "/")))
storage_resources <- jsonlite::fromJSON(here(paste("raw", SUBFOLDER, "STORAGE.json", sep = "/")))
