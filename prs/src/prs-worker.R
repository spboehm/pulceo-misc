# prs-worker.R
source("common.R")

install_and_load("redux")
install_and_load("jsonlite")

RenderReport <- function(ROOTFOLDER = Sys.getenv("PULCEO_DATA_DIR", "/tmp/psm-data"), subfolder = "sample") {
    # generate folder prefixes
    FOLDER_PFX_RAW <- paste(ROOTFOLDER, "raw", subfolder, sep = "/")
    FOLDER_PFX_REPORTS <- paste(ROOTFOLDER, "reports", subfolder, sep = "/")
    FOLDER_PFX_LATEX <- paste(ROOTFOLDER, "latex", subfolder, sep = "/")
    FOLDER_PFX_PLOTS <- paste(ROOTFOLDER, "plots", subfolder, sep = "/")

    # create directors
    lapply(list(FOLDER_PFX_RAW, FOLDER_PFX_REPORTS, FOLDER_PFX_LATEX, FOLDER_PFX_PLOTS), dir.create,  recursive = TRUE, showWarnings = FALSE)

    rmd_file <- paste0(Sys.getenv("RMARKDOWN_DIR", "../../pulceo-data-analytics"), "/pulceo-data-analytics.Rmd")
    if (!file.exists(rmd_file)) {
        stop(paste("RMarkdown file does not exist:", rmd_file))
    }
    rmarkdown::render(
        rmd_file,
        params = list(rootfolder = ROOTFOLDER, subfolder = subfolder),
        output_dir = FOLDER_PFX_REPORTS,
        output_file = "index.html"
    )
}

config <- list(
    redis_host = Sys.getenv("REDIS_HOST", "localhost"),
    redis_port = as.integer(Sys.getenv("REDIS_PORT", 6379))
)

r <- hiredis(host = config$redis_host, port = config$redis_port)

dir.create(PRS_LOG_DIRECTORY, recursive = TRUE, showWarnings = FALSE)
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
            RenderReport(subfolder = job$orchestrationId)
            cat("Report rendered:", job$orchestrationId, "\n")
        }, error = function(e) {
            cat("Render failed:", e$message, "\n")
        }, finally = {
        log_file <- paste0(PRS_LOG_DIRECTORY, "/", job$orchestrationId, ".log")
        file.copy(paste0(PRS_LOG_DIRECTORY, "/prs-worker.log"), log_file, overwrite = TRUE)
        file.create(paste0(PRS_LOG_DIRECTORY, "/prs-worker.log"), overwrite = TRUE)
        }
    )
}

cat("Worker exited.\n")
