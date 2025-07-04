source(here("includes/R/tasks.R"))
source(here("includes/resources/meta.R"))

tryCatch({
    TASKS_RAW <- read.csv(paste(FOLDER_PFX_RAW, "TASKS.csv", sep = "/"), skip = "3")
    TASKS <- TransformTasks(TASKS_RAW)
}, error = function(e) {
    message("Error loading or transforming TASKS: ", e$message)
    TASKS <<- data.frame()
}, finally = {
    TASK_PRESENT <- nrow(TASKS) > 0
})
