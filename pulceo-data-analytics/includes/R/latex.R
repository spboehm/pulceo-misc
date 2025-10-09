source(here("includes/R/libraries.R"))

install_and_load("kableExtra")
install_and_load("here")

SaveLatexTable <- function(summary, caption, label, filename, position = "t") {
  latex_table <- kbl(summary, "latex", escape = FALSE, caption = caption, booktabs = TRUE, linesep = "", vline = "", label = label, position = position, digits = 2) %>% kable_styling(full_width = TRUE)
  save_kable(latex_table, paste(FOLDER_PFX_LATEX, filename, sep = "/"))
}

SaveMultiColLatexTable <- function(summary, caption, label, filename, colnames, header, position = "t") {
  latex_table <- kbl(summary, "latex", escape = FALSE, caption = caption, booktabs = TRUE, linesep = "", vline = "", label = label, col.names = colnames, position = position, digits = 2) %>%
    kable_styling(full_width = TRUE) %>%
    add_header_above(header)

  save_kable(latex_table, paste(FOLDER_PFX_LATEX, filename, sep = "/"))
}

SaveLatexTableForTaskMetrics <- function(summary, caption, label, filename, position = "t") {
  summary <- summary %>%
      mutate(
          batchSize = as.character(batchSize),
          avg_sd_time = paste0(round(avg_time, 2), "/", round(sd_time, 2))
      ) %>%
      select(metric, start_status, end_status, batchSize, avg_sd_time) %>%
      pivot_wider(
          names_from = batchSize,
          values_from = avg_sd_time,
      ) %>%
      kable(
          format = "latex",
          label = label,
          booktabs = TRUE,
          linesep = c("", "", "\\addlinespace", "", "\\addlinespace"),
          escape = FALSE,
          caption = caption,
          col.names = c("Task metric", "$S_{1}$", "$S_{2}$", unique(summary$batchSize) %>% paste0(" ($\\mu/\\sigma$)")),
            align = c("l", "l", "l", rep("c", length(unique(summary$batchSize))))
      ) %>%
      add_header_above(
        c(" " = 1, " " = 2, "Batch size" = length(unique(summary$batchSize))),
        escape = FALSE
      ) %>%
      kable_styling(latex_options = c("hold_position", "scale_down"))
      
  save_kable(summary, paste(FOLDER_PFX_LATEX, "task-metrics-statistics.tex", sep = "/"))
}

