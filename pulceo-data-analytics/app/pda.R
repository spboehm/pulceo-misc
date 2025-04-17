# plumber.R
library(plumber)
library(rmarkdown)
library(jsonlite)



#* @get /render
function(req, res) {
    # input <- fromJSON(req$postBody)

    # TODO: the orchestration id
    SUBFOLDER <- "summersoc2025"
    dir.create(paste("raw", SUBFOLDER, sep = "/"), recursive = TRUE, showWarnings = FALSE)
    dir.create(paste("reports", SUBFOLDER, sep = "/"), recursive = TRUE, showWarnings = FALSE)
    # TODO: get resources and put in raw
    tasks_uri <- paste0("https://raw.githubusercontent.com/spboehm/pulceo-misc/refs/heads/feature/1mn-rework/pulceo-data-analytics/raw/", SUBFOLDER, "/TASKS.csv")
    events_uri <- paste0("https://raw.githubusercontent.com/spboehm/pulceo-misc/refs/heads/feature/1mn-rework/pulceo-data-analytics/raw/", SUBFOLDER, "/EVENTS.csv")
    requests_uri <- paste0("https://raw.githubusercontent.com/spboehm/pulceo-misc/refs/heads/feature/1mn-rework/pulceo-data-analytics/raw/", SUBFOLDER, "/REQUESTS.csv")

    # TODO: curl_tasks
    download.file(tasks_uri, paste("raw", SUBFOLDER, "TASKS.csv", sep = "/"))
    # TODO: curl_events
    download.file(events_uri, paste("raw", SUBFOLDER, "EVENTS.csv", sep = "/"))
    # TODO: curl_requests
    download.file(requests_uri, paste("raw", SUBFOLDER, "REQUESTS.csv", sep = "/"))

    rmd <- "pulceo-data-analytics-offloading.Rmd"
    rmarkdown::render(rmd,
        params = list(subfolder = SUBFOLDER),
        output_dir = paste0("reports", "/", subfolder = SUBFOLDER),
        output_file = "index.html"
    )


    # output_path <- tempfile(fileext = ".html")

    # render(rmd_path, output_file = output_path, params = input$params)

    # res$body <- jsonlite::toJSON(list(output = output_path))
    res$status <- 200
    res$body <- "OK"
    return(res)
}
