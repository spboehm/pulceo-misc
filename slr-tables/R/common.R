# function for loading packages

LoadPackage <- function(package) {
  if(!require(package, character.only = TRUE)){
    install.packages(package, repos = "http://cran.us.r-project.org")
    library(package, character.only = TRUE)
  }
}

