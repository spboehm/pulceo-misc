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
