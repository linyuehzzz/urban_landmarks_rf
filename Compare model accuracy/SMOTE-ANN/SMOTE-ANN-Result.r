> traindata.3 <- read.csv("traindata-4.csv", header = TRUE)
> testdata.3 <- read.csv("testdata-4.csv", header = TRUE)
> library(nnet)
Warning message:
程辑包‘nnet’是用R版本3.5.2 来建造的 
> bpnn <- nnet(landmark ~ ., data = traindata.3, size = 2, 
+                 rang = 0.1, maxit = 1000)
# weights:  35
initial  value 2503.208747 
final  value 2483.826922 
converged
> bpnn.pred <- predict(bpnn, testdata.3, type = "class")
> roc.curve(testdata.3$landmark, bpnn.pred)
Area under the curve (AUC): 0.552
> table(testdata.3$landmark,bpnn.pred)
   bpnn.pred
      N   Y
  N 662 746
  Y  37  64