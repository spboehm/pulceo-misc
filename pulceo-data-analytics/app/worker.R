# worker.R
library(redux)
library(rmarkdown)
library(jsonlite)
library(withr)

# functions
RenderReport <- function(subfolder = "summersoc2025") {
    dir.create(paste("raw", subfolder, sep = "/"), recursive = TRUE, showWarnings = FALSE)
    dir.create(paste("reports", subfolder, sep = "/"), recursive = TRUE, showWarnings = FALSE)
    dir.create(paste("latex", subfolder, sep = "/"), recursive = TRUE, showWarnings = FALSE)

    tasks_uri <- paste0("https://raw.githubusercontent.com/spboehm/pulceo-misc/refs/heads/feature/1mn-rework/pulceo-data-analytics/raw/", subfolder, "/TASKS.csv")
    events_uri <- paste0("https://raw.githubusercontent.com/spboehm/pulceo-misc/refs/heads/feature/1mn-rework/pulceo-data-analytics/raw/", subfolder, "/EVENTS.csv")
    requests_uri <- paste0("https://raw.githubusercontent.com/spboehm/pulceo-misc/refs/heads/feature/1mn-rework/pulceo-data-analytics/raw/", subfolder, "/REQUESTS.csv")

    download.file(tasks_uri, paste("raw", subfolder, "TASKS.csv", sep = "/"))
    download.file(events_uri, paste("raw", subfolder, "EVENTS.csv", sep = "/"))
    download.file(requests_uri, paste("raw", subfolder, "REQUESTS.csv", sep = "/"))

    rmd <- "../pulceo-data-analytics-offloading.Rmd"
    rmarkdown::render(
        rmd,
        params = list(subfolder = subfolder),
        output_dir = paste0("reports", "/", subfolder),
        output_file = "index.html"
    )
}

config <- list(
    redis_host = Sys.getenv("REDIS_HOST", "localhost"),
    redis_port = as.integer(Sys.getenv("REDIS_PORT", 6379))
)

r <- hiredis(host = config$redis_host, port = config$redis_port)

dir.create("pda-worker-logs", recursive = TRUE, showWarnings = FALSE)
cat("Worker started. Press Ctrl+C or send SIGTERM to exit.\n")

# Setup graceful shutdown
stop_worker <- FALSE
withr::defer(
    {
        cat("Caught exit signal. Shutting down worker gracefully...\n")
        stop_worker <<- TRUE
    },
    envir = globalenv()
)

while (!stop_worker) {
    # Optional sleep to avoid tight loop
    Sys.sleep(0.5)

    # Use short BRPOP timeout to remain responsive
    job_json <- r$BRPOP("rmd_jobs", 1)

    if (length(job_json) == 0) next # timeout

    job <- fromJSON(job_json[[2]])

    cat("Rendering report...\n")
    tryCatch(
        {
            RenderReport(job$orchestrationId)
            cat("Report rendered:", job$orchestrationId, "\n")
        },
        error = function(e) {
            cat("Render failed:", e$message, "\n")
        }
    )
    log_file <- paste0("pda-worker-logs/", job$orchestrationId, ".log")
    file.copy("pda-worker.log", log_file, overwrite = TRUE)
    file.create("pda-worker.log", overwrite = TRUE)
}

cat("Worker exited.\n")
