# plumber.R
library(plumber)
library(rmarkdown)
library(jsonlite)
library(redux)

r <- hiredis()

#* @get /render
function(req, res) {
    # input <- fromJSON(req$postBody)

    # TODO: the orchestration id
    job <- list(
        orchestrationId = "summersoc2025"
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
    print(orchestrationId)
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
