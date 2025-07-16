source(here("includes/R/libraries.R"))
source(here("includes/resources/meta.R"))

install_and_load("ggpubr")

theme_set(theme_minimal())
theme_update(plot.margin = margin(0.75, 5.5, 0, 5.5, "pt"))
GenerateBarPlotPercentage <- function(summary, title, ylim_factor = 1.0, vjust = 0.0) {
  plot <- ggplot(summary, aes(x = Node, y = Mean, fill = Node)) +
    geom_bar(stat = "identity", width = 0.75) +
    geom_errorbar(aes(x = Node, ymin = Mean - SD, ymax = Mean + SD), width = 0.3, colour = "blue") +
    geom_label(aes(label = format(round(Mean, digits = 2), nsmall = 2)), vjust = vjust, fill = "white") +
    ggtitle(title) +
    ylab("Utilization (%)") +
    ylim(0, max(summary$Mean + summary$SD) * ylim_factor) +
    theme(legend.position = "none") +
    scale_fill_manual(values = NODE_SCALE_FILLS)
  return(plot)
}

CreateBoxplot <- function(df, title) {
    ggplot(df, aes(y = time)) +
        geom_boxplot(fill = "skyblue", color = "darkblue") +
        labs(
            title = title,
            y = "Time (s)",
            x = ""
        )
        # theme_minimal()
}

CreateTaskMetricBoxplot <- function(df, title, y_label = "Time (s)", x_label = "Batch Size") {
  ggplot(df, aes(x = batchSize, y = time, fill = Run)) +
    geom_boxplot(color = "darkblue") +
    labs(title = title, y = y_label, x = x_label) +
    theme_minimal() +
    ylim(0, max(df$time * 1.10, na.rm = TRUE))
}

SavePlot <- function(filename, plot, width = 4, height = 3) {
  ggsave(paste(FOLDER_PFX_PLOTS, filename, sep = "/"), plot + theme(plot.margin = margin(0, 0, 0, 0, "pt")), width = width, height = height, device = cairo_pdf)
}
