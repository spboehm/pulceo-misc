source(here("includes/R/libraries.R"))

install_and_load("tidyverse")

TransformTasks <- function(df) {
    df <- df %>%
        select(
            policy, batchSize, layer, modifiedBy, modifiedById, modifiedOn, newStatus, previousStatus,
            taskSchedulingUUID, taskUUID, timestamp
        ) %>%
        mutate(Run = case_when(
            layer == "cloud-only" ~ "1",
            layer == "edge-only" ~ "2",
            layer == "joint" ~ "3",
            TRUE ~ policy
        ))

    # Transform all columns except 'timestamp' to factors
    df <- df %>%
        mutate(across(-c(timestamp, modifiedOn), as.factor)) %>%
        mutate(
            timestamp = ymd_hms(timestamp, tz = "UTC"),
            modifiedOn = ymd_hms(modifiedOn, tz = "UTC")
        )

    return(df)
}
