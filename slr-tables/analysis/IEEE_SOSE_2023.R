#library(markdown)
#rmarkdown::render("nodes.Rmd")

PlotDistribution <- function(distribution, title) {
  return (ggplot(distribution, aes(x=Property, y=Count)) + geom_bar(stat='identity', fill="#00457d") + ggtitle(title) + theme(axis.text.x = element_text(angle = 45, vjust = 0.5), axis.text = element_text(size = 12)))
}

occurences <- as.data.frame(sapply(nodesStaticProps, function (x) {ifelse(x=="y", 1, 0)}))
distribution <- as.data.frame(t(as.data.frame(lapply(occurences, sum))))
distribution$Property <- rownames(distribution)
colnames (distribution) <- c("Count", "Property")

# Type 
# Cloud, Fog, Edge, Gateway
type <- distribution[distribution$Property %in% c("Cloud", "Fog", "Edge", "Gateway"),]
type$Property <- gsub("_", "\n", type$Property)
typePlot <- PlotDistribution(type, "Type-related Properties")

# Topology
# Layer, Role, Location_Place, Location_GPS, Group
topology <- distribution[distribution$Property %in% c("Layer", "Role", "Location_Place", "Location_GPS", "Group"),]
topology$Property <- gsub("_", "\n", topology$Property)
topologyPlot <- PlotDistribution(topology, "Topology-related Properties")

# CPU
# CPU_MIPS, CPU_Cores, CPU_Threads, CPU_GFlop, CPU_Frequency, CPU_Shares, CPU_Slots
cpu <- distribution[distribution$Property %in% c("CPU_MIPS", "CPU_Cores", "CPU_Threads", "CPU_GFlop", "CPU_Frequency", "CPU_Shares", "CPU_Slots"),]
cpu$Property <- gsub("_", "\n", cpu$Property)
CPUPlot <- PlotDistribution(cpu, "CPU-related Properties")


# Other Resources
otherResources <- distribution[distribution$Property %in% c("Memory_Capacity", "Memory_Slots", "Disk_Capacity", "Disk_Slots", "Network_Capacity"),]
otherResources$Property <- gsub("_", "\n", otherResources$Property)
otherResourcesPlot <- PlotDistribution(otherResources, "(Other) Resources-related Properties")

# Arrange
(arrangedPlot <- ggarrange(typePlot, topologyPlot, CPUPlot, otherResourcesPlot))


