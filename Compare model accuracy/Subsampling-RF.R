#欠采样/随机抽样/随机森林
data <- read.csv("input_1.csv", header = TRUE)
train <- sample(nrow(data), 9/10*15085)
traindata <- data[train,]
testdata <- data[-train,]
library(ROSE)
usdata <- ovun.sample(landmark ~ ., data = traindata, method = "under", seed = 1)$data
library(randomForest)
set.seed(100)
rf_ntree <- randomForest(landmark~., data = usdata, ntree = 600, importance = TRUE)
pred <- predict(object = rf_ntree,newdata = testdata)
roc.curve(testdata$landmark, pred)
table(testdata$landmark,pred)

#SMOTE/分层抽样/随机森林
data <- read.csv("input_1.csv", header = TRUE)
table(data$landmark)
prop.table(table(data$landmark))
library(sampling)
train <- strata(data, stratanames = ("landmark"), 
       size = c(14076*9/10, 1009*9/10), method="srswor")
traindata <- data[train$ID_unit,]
testdata <- data[-train$ID_unit,]
table(traindata$landmark)
prop.table(table(traindata$landmark))
#train <- sample(nrow(data), 9/10*15085)
#traindata <- data[train,]
#testdata <- data[-train,]
library(DMwR)
smotedata <- SMOTE(landmark ~ ., traindata, perc.over = 150,perc.under = 200)
table(smotedata$landmark)
prop.table(table(smotedata$landmark))
library(randomForest)
set.seed(100)
rf_ntree <- randomForest(landmark~., data = smotedata, ntree = 1000, importance = TRUE)
plot(rf_ntree)
pred <- predict(object = rf_ntree,newdata = testdata)
roc.curve(testdata$landmark, pred)
table(testdata$landmark,pred)

#改变样本量
traindata <- read.csv("traindata.csv", header = TRUE)
train <- sample(nrow(traindata), 9/10*13576)
traindata <- traindata[train,]
testdata <- read.csv("testdata.csv", header = TRUE)
testdata <- rbind(traindata[1,],testdata)
testdata <- testdata[-1,]
library(DMwR)
smotedata <- SMOTE(landmark ~ ., traindata, perc.over = 150,perc.under = 195)
table(smotedata$landmark)
prop.table(table(smotedata$landmark))
library(randomForest)
set.seed(100)
rf_ntree <- randomForest(landmark~., data = smotedata, ntree = 600, importance = TRUE)
pred <- predict(object = rf_ntree,newdata = testdata)
library(ROSE)
roc.curve(testdata$landmark, pred)
table(testdata$landmark,pred)

#标准化
traindata.2 <- read.csv("traindata-3.csv", header = TRUE)
testdata.2 <- read.csv("testdata-3.csv", header = TRUE)
smotedata.scale <- scale(traindata.2[,2:13], center = TRUE, scale = FALSE)
testdata.scale <- scale(testdata.2[,2:13], center = TRUE, scale = FALSE)

#BP神经网络（单层）nnet
traindata.3 <- read.csv("traindata-4.csv", header = TRUE)
testdata.3 <- read.csv("testdata-4.csv", header = TRUE)
library(nnet)
bpnn <- nnet(landmark ~ ., data = traindata.3, size = 2, 
                rang = 0.1, maxit = 1000)
bpnn.pred <- predict(bpnn, testdata.3, type = "class")
roc.curve(testdata.3$landmark, bpnn.pred)
table(testdata.3$landmark,bpnn.pred)

#BP神经网络neuralnet
library(neuralnet)
traindata.3$landmark = as.numeric(traindata.3$landmark)
testdata.3$landmark = as.numeric(testdata.3$landmark)
net <- neuralnet(landmark ~ lon+lat+feature.level+highest.road.level+road.density+
                   GDP.level+same.features.in.500.buffer+different.features.in.500.buffer+
                   traffic.stations.nearby.in.Baidu.Map+crowd.density+Bing.search.results+
                   Weibo.search.results+Baidu.Map.poi+category_2+category_1, 
                 data = traindata.3, hidden = 2, threshold = 0.01)
predict <- compute(net,testdata.3[,-1])
roc.curve(testdata.3$landmark, predict$net.result)
table(testdata.3$landmark,predict$net.result)

#变量重要性
importance(rf_ntree,type = 1, scale = TRUE)
importance(rf_ntree,type = 2, scale = TRUE)
varImpPlot(rf_ntree)


write.csv(traindata,"traindata.csv")
write.csv(testdata,"testdata.csv")
write.csv(smotedata,"traindata-2.csv")
write.csv(testdata,"testdata-2.csv")
write.csv(smotedata.scale,"traindata-4.csv")
write.csv(testdata.scale,"testdata-4.csv")

#画ROC曲线
library(pROC)
roc <- roc(testdata$landmark, pred)
plot(roc, print.auc = TRUE, auc.polygon = TRUE, grid = c(0.1, 0.2), 
     grid.col = c("green", "red"), max.auc.polygon = TRUE, 
     auc.polygon.col = "skyblue", print.thres = TRUE)

