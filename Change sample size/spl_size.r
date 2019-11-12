data <- read.csv("ReduceSampleSize.csv",header = TRUE)

#recall
plot(x = data$Reduction, y = data$Recall, xlab = "Reduction of sample size", 
     ylab = "Model performance", type = "b", pch = 17)

#precision
lines(x = data$Reduction, y = data$Precision,type = "b", pch = 16)

#f-measure
lines(x = data$Reduction, y = data$F.measure,type = "b", pch = 7)