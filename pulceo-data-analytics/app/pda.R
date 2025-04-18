# plumber.R
library(plumber)
library(rmarkdown)
library(jsonlite)
library(redux)

config <- list(
    redis_host = Sys.getenv("REDIS_HOST", "localhost"),
    redis_port = as.integer(Sys.getenv("REDIS_PORT", 6379))
)

r <- hiredis(host = config$redis_host, port = config$redis_port)

#* @get /render/<orchestrationId>
function(orchestrationId, res) {
    # input <- fromJSON(req$postBody)
    # TODO: the orchestration id
    cat(sprintf("Received render request with orchestrationId: %s\n", orchestrationId))
    job <- list(
        orchestrationId = orchestrationId
    )

    r$LPUSH("rmd_jobs", toJSON(job))

    res$status <- 200
    res$body <- "OK"
    return(res)
}

#* @get /logs/<orchestrationId>
function(orchestrationId, res) {
    if (missing(orchestrationId)) {
        res$status <- 400
        res$body <- "Missing orchestrationId"
        return(res)
    }

    log_file <- paste0("pda-worker-logs/", orchestrationId, ".log")
    if (file.exists(log_file)) {
        logs <- readLines(log_file)
    } else {
        logs <- character(0)
    }

    if (length(logs) == 0) {
        res$status <- 404
        res$body <- "No logs found for the given orchestrationId"
        return(res)
    }

    res$status <- 200
    res$body <- toJSON(logs)
    return(res)
}
