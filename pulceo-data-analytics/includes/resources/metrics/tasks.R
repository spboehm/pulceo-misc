source(here("includes/resources/meta.R"))
source(here("includes/resources/metrics/requests.R"))
source(here("includes/R/tasks.R"))

TASKS_FILE_PATH <- paste(FOLDER_PFX_RAW, "TASKS.csv", sep = "/")

if (!file.exists(TASKS_FILE_PATH)) {
    TASKS_FILE_PATH <- paste(FOLDER_PFX_RAW, "TASK_STATUS_LOG.csv", sep = "/")
}

tryCatch({
    TASKS_RAW <- read.csv(TASKS_FILE_PATH, skip = "3")
    TASKS <- TransformTasks(TASKS_RAW)
}, error = function(e) {
    message("Error loading or transforming TASKS: ", e$message)
    TASKS <<- data.frame()
}, finally = {
    TASKS_PRESENT <- nrow(TASKS) > 0
})

if (TASKS_PRESENT) {
    requests_combined <- TASKS %>%
        select(taskUUID, batchSize, layer) %>%
        inner_join(REQUESTS, by = c("taskUUID" = "destinationHost")) %>%
        select(taskUUID, batchSize, layer, requestType, timestamp, unit, X_value, X_field) %>%
        mutate(Run = case_when(
            layer == "cloud-only" ~ "1",
            layer == "edge-only" ~ "2",
            layer == "joint" ~ "3"
        )) %>%
        mutate(X_value = X_value / 1000)
}
