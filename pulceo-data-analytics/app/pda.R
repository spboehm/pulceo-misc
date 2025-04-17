# plumber.R
library(plumber)
library(rmarkdown)

#* @get /render
function(req, res) {
    # input <- jsonlite::fromJSON(req$postBody)
    # rmd_path <- input$rmd_path # e.g., "template.Rmd"
    # output_path <- tempfile(fileext = ".html")

    # render(rmd_path, output_file = output_path, params = input$params)

    # res$body <- jsonlite::toJSON(list(output = output_path))
    res$status <- 200
    res$body <- "OK"
    return(res)
}
