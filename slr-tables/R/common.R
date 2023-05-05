# function for loading packages

LoadPackage <- function(package) {
  if(!require(package, character.only = TRUE)){
    install.packages(package)
    library(package)
  }
}

