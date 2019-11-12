2018-10 from:林玥
修改2019-01-03

UP&DOWN-RF

-------输入数据-------
#读入训练集与验证集
traindata <- read.csv("traindata.csv", header = TRUE)
testdata <- read.csv("testdata.csv", header = TRUE)



-------非均衡数据处理-------
#加载R包
library(ROSE)

#检查poi数据的不平衡度
table(traindata$landmark)
prop.table(table(traindata$landmark))

#SMOTE采样
rosedata <- ROSE(landmark ~ ., data = traindata, seed = 1)$data
table(rosedata$landmark)
prop.table(table(rosedata$landmark))


-------非均衡数据处理*2-------
library(DMwR)

table(traindata$landmark)
prop.table(table(traindata$landmark))

smotedata <- SMOTE(landmark ~ ., traindata, perc.over = 1200,perc.under = 100)
table(smotedata$landmark)
prop.table(table(smotedata$$landmark))


-------随机森林（Random Forest）模型搭建-------
#加载R包
library(randomForest)

#设定随机数种子
set.seed(100)

#运行随机森林模型
rf_ntree <- randomForest(landmark~., data = rosedata, ntree = 600, importance = TRUE)
rf_ntree <- randomForest(landmark~., data = smotedata, ntree = 600, importance = TRUE)

#输出模型结果
print(rf_ntree)

#查看每一棵树的误判率
plot(rf_ntree)

#计算模型变量的重要性
importance(rf_ntree,type = 1, scale = TRUE)
importance(rf_ntree,type = 2, scale = TRUE)
varImpPlot(rf_ntree)



-------检测测试集-------
#随机森林预测
pred <- predict(object = rf_ntree,newdata = testdata)

#AUC曲线
roc.curve(testdata$landmark, pred)

#另一种AUC曲线
library(pROC)
roc <- roc(testdata$landmark, pred)
plot(roc, print.auc = TRUE, auc.polygon = TRUE, grid = c(0.1, 0.2), grid.col = c("green", "red"), max.auc.polygon = TRUE, auc.polygon.col = "skyblue", print.thres = TRUE)

#计算混淆矩阵
prediction <- predict(object = rf_ntree,newdata = testdata,type = "response")
actual <- testdata$landmark
confusionmtx <- table(actual,prediction)
confusionmtx

