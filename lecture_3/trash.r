library(dplyr)
library(ggplot2)

data <- read.table('data/KDD2009/orange_small_train.data.gz', header=TRUE, sep="\t", na.strings=c('NA', ''))

churn <- read.table('data/KDD2009/orange_small_train_churn.labels', header=FALSE, sep = '\t')
appetency <- read.table('data/KDD2009/orange_small_train_appetency.labels', header=FALSE, sep='\t')
upselling <- read.table('data/KDD2009/orange_small_train_upselling.labels', header=FALSE, sep='\t')

data$churn <- churn$V1
data$appetency <- appetency$V1
data$upselling <- upselling$V1


set.seed(729375)


data$rgroup <- runif(dim(data)[1])

#data <- tbl_df(data)
train <-subset(data, rgroup <= 0.9)
test <- subset(data, rgroup > 0.9)

outcomes <- c('churn', 'appetency', 'upselling')
vars <- setdiff(colnames(train), c(outcomes, 'rgroup'))
cat.vars <- vars[sapply(train[,vars],class) %in% c('factor', 'character')]
num.vars <- vars[sapply(train[,vars],class) %in% c('numeric','integer')]

use.for.calibration <- rbinom(n=dim(train)[[1]], size=1, prob=0.1) > 0

calibration <- subset(train, use.for.calibration)

train <- subset(train, !use.for.calibration)

outcome <- 'churn'

pos <- '1'

rm(list=c('data', 'churn', 'appetency', 'upselling', 'use.for.calibration'))


#Single variable model

business analysts pivot table (which promotes values or levels of a feature to be families of new columns)
statisticiams contingency table (where each possibility is a given column name)


table218 <- table(Var218=train$Var218, churn=train$churn, useNA='ifany')

prop.table(table218, 1)*100


mkPredC <- function(outCol, varCol, appCol) {
  pPos <- sum(outCol == pos) / length(outCol)
  naTab <- table(as.factor(outCol[is.na(varCol)]))
  pPosWna <- (naTab/sum(naTab))[pos]
  vTab <- table(as.factor(outCol), varCol)
  pPosWv <- (vTab[pos,]+1.0e-3*pPos)/(colSums(vTab)+1.0e-3)
  pred <- pPosWv[appCol]
  pred[is.na(appCol)] <- pPosWna
  pred[is.na(pred)] <- pPos
  pred
}


for (v in cat.vars) {
  pi <- paste('pred',v, sep='')
  train[,pi] <- mkPredC(train[,outcome],train[,v], train[,v])
  calibration[,pi] <- mkPredC(train[,outcome],train[,v], calibration[,v])
  test[,pi] <- mkPredC(train[,outcome], train[,v], test[,v])
}

library(ROCR)

calcAUC <- function(predcol, outcol) {
  perf <- performance(prediction(predcol, outcol == pos), 'auc')
  as.numeric(perf@y.values)
}

for (v in cat.vars) {
  pi <- paste('pred', v, sep='')
  aucTrain <- calcAUC(train[,pi], train[, outcome])
  if(aucTrain >=0.8) {
    aucCal <- calcAUC(calibration[,pi], calibration[,outcome])
    print(sprintf("%s, trainAUC: %4.3f calibrationAUC: %4.3f", pi, aucTrain, aucCal))
  }
}


mkPredN <- function(outCol, varCol, appCol) {
  cuts <- unique(as.numeric(quantile(varCol, probs=seq(0,1,0.1), na.rm=TRUE)))
  varC <- cut(varCol, cuts)

  appC <- cut(appCol, cuts)

  mkPredC(outCol, varC, appC)
}

for ( v in num.vars) {
  pi <- paste('pred', v, sep='')
  train[,pi] <- mkPredN(train[,outcome], train[,v], train[,v])
  calibration[,pi] <- mkPredN(train[,outcome], train[,v], calibration[,v])
  test[,pi] <- mkPredN(train[,outcome], train[,v], test[,v])

  aucTrain <- calcAUC(train[,pi], train[,outcome])
  if(aucTrain >= 0.55) {
    aucCal <- calcAUC(calibration[,pi], calibration[,outcome])
    print(sprintf("%s, trainAUC: %4.3f calibrationAUC: %4.3f", pi, aucTrain, aucCal))
  }
}


# Cross-validation

fCross <- function() {
  useForCalRep <- rbinom(n=dim(train)[[1]], size=1, prob=0.1) > 0
  predRep <-mkPredC(train[!useForCalRep, outcome], train[!useForCalRep, var], train[useForCalRep, var])
  calcAUC(predRep, train[useForCalRep, outcome])
}

aucs <- replicate(100, fCross())
mean(aucs)
sd(aucs)


# Variable selection



logLikelyhood <- function(outCol, predCol) {
  sum(ifelse(outCol==pos, log(predCol), log(1-predCol)))
}

entropy <- function(x) {
  xpos <- x[x>0 & !is.na(x)]
  scaled <- xpos/sum(xpos)
  sum(-scaled*log(scaled,2))
}


selVars <- c()

minStep <- 5

baseRateCheck<- logLikelyhood(calibration[,outcome], sum(calibration[,outcome]==pos) / length(calibration[,outcome]))

for(v in cat.vars) {
  pi <- paste('pred', v, sep='')
  liCheck <- 2*((logLikelyhood(calibration[,outcome], calibration[,pi]) - baseRateCheck))
  if(liCheck > minStep) {
    print(sprintf("%s, calibrationScore: %g",pi, liCheck))
    selVars <- c(selVars, pi)
  }
}


for(v in num.vars) {
  pi <- paste('pred', v, sep='')
  liCheck <- 2*((logLikelyhood(calibration[,outcome], calibration[,pi]) - baseRateCheck) - 1)
  if(liCheck >= minStep) {
    print(sprintf("%s, calibrationScore: %g",pi, liCheck))
    selVars <- c(selVars, pi)
  }
}

# Multivariable

library('rpart')

fV <- paste(outcome, '>0 ~ ', paste(c(cat.vars,num.vars), collapse = ' + '), sep='')

tmodel <- rpart(fV, data=train)

train$tpred <- predict(tmodel, newdata=train)
calibration$tpred <- predict(tmodel, newdata=calibration)
test$tpred <- predict(tmodel, newdata=test)

print(calcAUC(train$tpred, train[,outcome]))

print(calcAUC(test$tpred, test[,outcome]))

print(calcAUC(calibration$tpred, calibration[,outcome]))


# Segundo intento

tVars <- paste('pred', c(cat.vars, num.vars), sep='')

fV2 <- paste(outcome, '>0 ~ ', paste(tVars, collapse = ' + '), sep='')

tmodel2 <- rpart(fV2, data=train)

train$tpred2 <- predict(tmodel2, newdata=train)
calibration$tpred2 <- predict(tmodel2, newdata=calibration)
test$tpred2 <- predict(tmodel2, newdata=test)

print(calcAUC(train$tpred2, train[,outcome]))

print(calcAUC(test$tpred2, test[,outcome]))

print(calcAUC(calibration$tpred2, calibration[,outcome]))

# ¿Quizá muy complejo?

tmodel3 <- rpart(fV2, data=train, control=rpart.control(cp=0.001, minsplit=1000, minbucket=1000, maxdepth=5))

train$tpred3 <- predict(tmodel3, newdata=train)
calibration$tpred3 <- predict(tmodel3, newdata=calibration)
test$tpred3 <- predict(tmodel3, newdata=test)

print(calcAUC(train$tpred3, train[,outcome]))

print(calcAUC(test$tpred3, test[,outcome]))

print(calcAUC(calibration$tpred3, calibration[,outcome]))


# With variable selection

fV4 <- paste(outcome, '>0 ~ ', paste(selVars, collapse= ' + '), sep='')

tmodel4 <- rpart(fV4, data=train, control=rpart.control(cp=0.001, minsplit=1000, minbucket=1000, maxdepth=5))

train$tpred4 <- predict(tmodel4, newdata=train)
calibration$tpred4 <- predict(tmodel4, newdata=calibration)
test$tpred4 <- predict(tmodel4, newdata=test)

print(calcAUC(train$tpred4, train[,outcome]))

print(calcAUC(test$tpred4, test[,outcome]))

print(calcAUC(calibration$tpred4, calibration[,outcome]))


## K-NN

library('class')
nK <- 200
knnTrain <- train[,selVars]
knnCl <- train[,outcome] == pos

knnPred <- function(df) {
  knnDecision <- knn(knnTrain, df, knnCl, k=nK, prob=TRUE)
  ifelse(knnDecision==TRUE, attributes(knnDecision)$prob, 1- (attributes(knnDecision)$prob))
}

print(calcAUC(knnPred(train[,selVars]), train[,outcome]))

print(calcAUC(knnPred(calibration[,selVars]), calibration[,outcome]))

print(calcAUC(knnPred(test[,selVars]), test[,outcome]))


calibration$kpred <- knnPred(calibration[,selVars])
ggplot(data=calibration) + geom_density(aes(x=kpred, color=as.factor(churn), linetype=as.factor(churn)))


plotROC <- function(predcol, outcol) {
  perf <- performance(prediction(predcol, outcol == pos), 'tpr', 'fpr')
  pf <- data.frame(FPR = perf@x.values[[1]], TPR=perf@y.values[[1]])

  ggplot() + geom_line(data=pf, aes(x=FPR, y=TPR)) + geom_line(aes(x=c(0,1), y=c(0,1)))
}

print(plotROC(knnPred(test[,selVars]), test[,outcome]))


# Regresión Logística

gmodel <- glm(as.formula(fV4), data=train, family=binomial(link='logit'))

print(calcAUC(predict(gmodel, newdata=train), train[,outcome]))

print(calcAUC(predict(gmodel, newdata=calibration), calibration[,outcome]))

print(calcAUC(predict(gmodel, newdata=test), test[,outcome]))


print(plotROC(predict(gmodel, newdata=test), test[,outcome]))

print(plotROC(predict(tmodel, newdata=test), test[,outcome]))


# Random Forest

library(randomForest)

fmodel <- randomForest(as.formula(fV4), data=train, ntree=100, nodesize=7, importance=TRUE, type='classification')

train$fpred <- predict(fmodel, newdata=train)
calibration$fpred <- predict(fmodel, newdata=calibration)
test$fpred <- predict(fmodel, newdata=test)

print(calcAUC(train$fpred, train[,outcome]))

print(calcAUC(test$fpred, test[,outcome]))

print(calcAUC(calibration$fpred, calibration[,outcome]))

print(plotROC(predict(fmodel, newdata=test), test[,outcome]))


varImp <- importance(fmodel)

varImp[1:10,]

varImpPlot(fmodel, type=1)


# Problemas

- Training Variance Small changes in the makeup of the training set result in models that make substantially different predictis (trees exhibit this) -> bagging & random forest

- Non-monotone effects - Regressions treat numeric variables in monotone matter, this is often not the case in the real world (healthy weight, is an example), Generealized additive models

- Linearly inseparable data: Often the concept We're trying to learn is not a linear combination of the original variables (BMI w/h^2 can't be discovered by regression ) -> kernel methods, svm
