> traindata <- read.csv("traindata.csv", header = TRUE)
> testdata <- read.csv("testdata.csv", header = TRUE)
> set.seed(100)
> library(randomForest)
> set.seed(100)
> rf_ntree <- randomForest(landmark~., data = traindata, ntree = 2000, importance = TRUE)
> plot(rf_ntree)
> pred <- predict(object = rf_ntree,newdata = testdata)
> roc.curve(testdata$landmark, pred)
Area under the curve (AUC): 0.534
> table(testdata$landmark,pred)
   pred
       N    Y
  N 1405    3
  Y   94    7