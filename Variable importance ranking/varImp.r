#MeanDecreaseGini
library(ggplot2)
data <- read.csv("MeanDecreaseGini.csv", header = TRUE)
ggplot(data, aes(reorder(row.names(data), data$Value), data$Value))+ geom_bar(stat = "identity", fill = "steelblue")+coord_flip()

#MeanDecreaseAccuracy
library(ggplot2)
data <- read.csv("MeanDecreaseAccuracy.csv", header = TRUE)
ggplot(data, aes(reorder(row.names(data), data$Value), data$Value))+ geom_bar(stat = "identity", fill = "steelblue")+coord_flip()
