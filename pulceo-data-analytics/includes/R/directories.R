# directories.R

if (!exists("ROOTFOLDER")) {
    stop("ROOTFOLDER is not defined!")
}

if (!exists("SUBFOLDER")) {
    stop("SUBFOLDER is not defined!")
}

# directories
FOLDER_PFX_RAW <<- paste(ROOTFOLDER, "raw", SUBFOLDER, sep = "/")
FOLDER_PFX_REPORTS <<- paste(ROOTFOLDER, "reports", SUBFOLDER, sep = "/")
FOLDER_PFX_LATEX <<- paste(ROOTFOLDER, "latex", SUBFOLDER, sep = "/")
FOLDER_PFX_PLOTS <<- paste(ROOTFOLDER, "plots", SUBFOLDER, sep = "/")

# create directors
lapply(list(FOLDER_PFX_RAW, FOLDER_PFX_REPORTS, FOLDER_PFX_LATEX, FOLDER_PFX_PLOTS), dir.create,  recursive = TRUE, showWarnings = FALSE)
