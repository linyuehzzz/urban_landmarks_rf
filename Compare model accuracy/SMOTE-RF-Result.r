> data <- read.csv("input_1.csv", header = TRUE)
> table(data$landmark)

    N     Y 
14076  1009 
> prop.table(table(data$landmark))

         N          Y 
0.93311236 0.06688764 
> library(sampling)
> n <- round(9/10*nrow(data)/3)
> train <- strata(data, stratanames = ("landmark"), 
+        size = c(14076*9/10, 1009*9/10),, method="srswor")
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
> smotedata <- SMOTE(landmark ~ ., traindata, perc.over = 150,perc.under = 195)
> table(smotedata$landmark)

   N    Y 
1770 1816 
> prop.table(table(smotedata$landmark))

        N         Y 
0.4935862 0.5064138 
> library(randomForest)
> set.seed(100)
> rf_ntree <- randomForest(landmark~., data = smotedata, ntree = 600, importance = TRUE)
> pred <- predict(object = rf_ntree,newdata = testdata)
> roc.curve(testdata$landmark, pred)
Area under the curve (AUC): 0.814
> table(testdata$landmark,pred)
   pred
       N    Y
  N 1135  273
  Y   18   83
> importance(rf_ntree,type = 1, scale = TRUE)
                                     MeanDecreaseAccuracy
lon                                              35.10535
lat                                              52.59334
feature.level                                    98.61635
highest.road.level                               20.19906
road.density                                     37.83646
GDP.level                                        25.74159
same.features.in.500.buffer                      39.83412
different.features.in.500.buffer                 43.51922
traffic.stations.nearby.in.Baidu.Map             39.44221
crowd.density                                    38.65292
Bing.search.results                              52.74905
Weibo.search.results                             65.89811
Baidu.Map.poi                                    12.66796
building                                         30.59576
category_2                                       41.32356
category_1                                       21.23061
> importance(rf_ntree,type = 2, scale = TRUE)
                                     MeanDecreaseGini
lon                                          82.81873
lat                                         129.49799
feature.level                               395.20606
highest.road.level                           38.64444
road.density                                 90.92090
GDP.level                                    36.87733
same.features.in.500.buffer                  82.17458
different.features.in.500.buffer             90.66348
traffic.stations.nearby.in.Baidu.Map         81.52226
crowd.density                                99.47272
Bing.search.results                         184.04190
Weibo.search.results                        205.79951
Baidu.Map.poi                                14.14856
building                                     84.80672
category_2                                  141.21173
category_1                                   34.13857
> varImpPlot(rf_ntree)
> write.csv(traindata,"traindata.csv")
> write.csv(testdata,"testdata.csv")
> pred <- predict(object = rf_ntree,newdata = testdata)
> roc.curve(testdata$landmark, pred)
Area under the curve (AUC): 0.814
> table(testdata$landmark,pred)
   pred
       N    Y
  N 1134  274
  Y   18   83
> 