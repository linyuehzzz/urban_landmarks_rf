> library(sampling)
> train <- strata(data, stratanames = ("landmark"), 
+        size = c(14076*9/10, 1009*9/10), method="srswor")
> traindata <- data[train$ID_unit,]
> testdata <- data[-train$ID_unit,]
> table(traindata$landmark)

    N     Y 
12668   908 
> prop.table(table(traindata$landmark))

         N          Y 
0.93311727 0.06688273 
> #train <- sample(nrow(data), 9/10*15085)
> #traindata <- data[train,]
> #testdata <- data[-train,]
> library(DMwR)
> smotedata <- SMOTE(landmark ~ ., traindata, perc.over = 150,perc.under = 200)
> table(smotedata$landmark)

   N    Y 
1816 1816 
> prop.table(table(smotedata$landmark))

  N   Y 
0.5 0.5 
> library(randomForest)
> set.seed(100)
> rf_ntree <- randomForest(landmark~., data = smotedata, ntree = 2000, importance = TRUE)
> plot(rf_ntree)
> pred <- predict(object = rf_ntree,newdata = testdata)
> roc.curve(testdata$landmark, pred)
Area under the curve (AUC): 0.841
> table(testdata$landmark,pred)
   pred
       N    Y
  N 1170  238
  Y   15   86
> importance(rf_ntree,type = 1, scale = TRUE)
                                     MeanDecreaseAccuracy
feature.level                                   150.16796
highest.road.level                               43.49751
road.density                                     76.24545
GDP.level                                        49.38073
same.features.in.500.buffer                      72.34098
different.features.in.500.buffer                 73.34801
traffic.stations.nearby.in.Baidu.Map             60.08727
crowd.density                                    76.32505
Bing.search.results                              94.88013
Weibo.search.results                            110.44568
Baidu.Map.poi                                    34.79795
building                                         65.54107
category_2                                       79.69715
category_1                                       45.92556
urban.centrality                                 72.11220
> importance(rf_ntree,type = 2, scale = TRUE)
                                     MeanDecreaseGini
feature.level                               357.25208
highest.road.level                           50.71455
road.density                                103.75986
GDP.level                                    60.69813
same.features.in.500.buffer                  94.75692
different.features.in.500.buffer             95.27267
traffic.stations.nearby.in.Baidu.Map         86.45636
crowd.density                               111.54738
Bing.search.results                         196.17276
Weibo.search.results                        214.39647
Baidu.Map.poi                                19.52847
building                                    120.37494
category_2                                  163.00821
category_1                                   50.15126
urban.centrality                             89.25954
> varImpPlot(rf_ntree)