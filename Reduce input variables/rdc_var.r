#Accuracy
data <- read.csv("ReduceVariableAccuracy.csv",header = TRUE)
#recall
plot(x = data$Reduce.Feature, y = data$Recall, xlab = "Reducing variable number", 
     ylab = "Model performance", type = "b", ylim =c(0.65,0.9), pch = 17)
#precision
lines(x = data$Reduce.Feature, y = data$Precision, type = "b", pch = 16)
#f-measure
lines(x = data$Reduce.Feature, y = data$F.measure, type = "b", pch = 7)

#Gini
data <- read.csv("ReduceVariableGini.csv",header = TRUE)
#recall
plot(x = data$Reduce.Feature, y = data$Recall, xlab = "Reducing variable number", 
     ylab = "Model performance", type = "b", ylim =c(0.65,0.9), pch = 17)
#precision
lines(x = data$Reduce.Feature, y = data$Precision, type = "b", pch = 16)
#f-measure
lines(x = data$Reduce.Feature, y = data$F.measure, type = "b", pch = 7)