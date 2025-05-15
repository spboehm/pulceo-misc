# functions
install_and_load <- function(pkg, mirror = "https://cloud.r-project.org") {
  # Set default CRAN mirror and silent options
  options(repos = c(CRAN = mirror))
  options(install.packages.check.source = "no")
  options(ask = FALSE)

  # Install if missing
  if (!requireNamespace(pkg, quietly = TRUE)) {
    message(sprintf("Installing '%s'...", pkg))
    install.packages(pkg, dependencies = TRUE, quiet = TRUE)
  }

  # Load package quietly
  suppressPackageStartupMessages(
    library(pkg, character.only = TRUE, quietly = TRUE, warn.conflicts = FALSE)
  )
}

# plumber.R
install_and_load("plumber")
install_and_load("rmarkdown")
install_and_load("jsonlite")
install_and_load("redux")

config <- list(
    redis_host = Sys.getenv("REDIS_HOST", "localhost"),
    redis_port = as.integer(Sys.getenv("REDIS_PORT", 6379))
)

r <- hiredis(host = config$redis_host, port = config$redis_port)

#* @post /reports
function(req, res) {
    
    # validate
    input <- tryCatch({
        fromJSON(req$postBody)
    }, error = function(e) {
        res$status <- 400
        res$body <- "Invalid JSON in request body"
        return(res)
    })

    if (is.null(input$orchestrationUUID) || input$orchestrationUUID == "") {
        res$status <- 400
        res$body <- "Missing or empty orchestrationUUID"
        return(res)
    }

    # parse the orchestrationId
    orchestrationId <- input$orchestrationUUID
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
