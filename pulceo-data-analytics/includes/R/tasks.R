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

CalculateTaskSchedulingMetric <- function(df, start_status, end_status, ...) {
    group_by_vars <- enquos(...)
    df %>%
        filter(newStatus %in% c(start_status, end_status)) %>% # Filter relevant statuses
        group_by(taskUUID, !!!group_by_vars) %>% # Group by taskUUID and additional properties
        arrange(modifiedOn) %>% # Ensure chronological order
        summarize(
            time = as.numeric(
                difftime(
                    modifiedOn[newStatus == end_status][1],
                    modifiedOn[newStatus == start_status][1],
                    units = "secs"
                )
            )
        ) %>%
        ungroup() # Remove grouping
}

CalculateOverallMakespan <- function(df, ...) {
    group_by_vars <- enquos(...)

    # Ensure the dataframe has valid timestamps
    if (nrow(df) == 0) {
        return(NA) # Handle empty dataframe
    }

    # Remove rows with NA in the time column
    df <- df %>%
        filter(!is.na(time))

    # Check again if the dataframe is empty after filtering
    if (nrow(df) == 0) {
        return(NA) # Handle case where all rows had NA
    }

    # Group by the specified variables (if any) and calculate the overall makespan time
    overall_makespan <- df %>%
        group_by(!!!group_by_vars) %>%
        summarize(
            makespan = as.numeric(difftime(max(time), min(time), units = "secs")),
            .groups = "drop"
        )

    return(overall_makespan)
}

CalculateWaitingTimeStats <- function(df, start_status, end_status, metric_name) {
    df %>%
        group_by(batchSize) %>%
        summarize(
            start_status = first(start_status),
            end_status = first(end_status),
            sd_time = sd(time, na.rm = TRUE),
            avg_time = mean(time, na.rm = TRUE),
            .groups = "drop"
        ) %>%
        mutate(metric = metric_name)
}
