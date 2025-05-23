source(here("includes/R/libraries.R"))

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
    scale_fill_manual(values = node_scale_fills)
  return(plot)
}

SavePlot <- function(filename, plot, width = 4, height = 3) {
  ggsave(here(paste0("plots/", SUBFOLDER, "/", filename)), plot + theme(plot.margin = margin(0, 0, 0, 0, "pt")), width = width, height = height, device = cairo_pdf)
}
