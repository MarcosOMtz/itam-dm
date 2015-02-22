

german.url <- paste('http://archive.ics.uci.edu/ml',
                    '/machine-learning-databases/statlog',
                    '/german/german.data',
                    sep='')

german.data <- read.table(german.url, 
                          stringsAsFactors = FALSE, 
                          header = FALSE)


source("0-load.r")
source("1-prepare.r")
source("metadata.r")

library(ggplot2)
library(gridExtra)
library(corrplot)
library(plotrix)
library(dplyr)
library(tidyr)
library(reshape2)
library(randomForest)
library(leaps)


install.packages("gridExtra")

german.data  <-  load()

colnames(german.data) <- german.colnames

german.data$good.loan <- as.factor(
  ifelse(
    german.data$good.loan == 1, 
    'GoodLoan', 
    'BadLoan'
  )
)

german.codes <- list('A11'='... < 0 DM',
                     'A12'='0 <= ... < 200 DM', 
                     'A13'='... >= 200 DM / salary assignments for at least 1 year',
                     'A14'='no checking account', 
                     'A30'='no credits taken/all credits paid back duly',
                     'A31'='all credits at this bank paid back duly', 
                     'A32'='existing credits paid back duly till now',
                     'A33'='delay in paying off in the past', 
                     'A34'='critical account/other credits existing (not at this bank)',
                     'A40'='car (new)', 
                     'A41'='car (used)', 
                     'A42'='furniture/equipment',
                     'A43'='radio/television', 'A44'='domestic appliances', 'A45'='repairs',
                     'A46'='education', 'A47'='(vacation - does not exist?)',
                     'A48'='retraining', 'A49'='business', 'A410'='others', 'A61'='... < 100 DM',
                     'A62'='100 <= ... < 500 DM', 'A63'='500 <= ... < 1000 DM',
                     'A64'='.. >= 1000 DM', 'A65'='unknown/ no savings account',
                     'A71'='unemployed', 'A72'='... < 1 year', 'A73'='1 <= ... < 4 years', 
                     'A74'='4 <= ... < 7 years', 'A75'='.. >= 7 years', 'A91'='male : divorced/separated',
                     'A92'='female : divorced/separated/married',
                     'A93'='male : single',
                     'A94'='male : married/widowed', 
                     'A95'='female : single',
                     'A101'='none', 
                     'A102'='co-applicant',
                     'A103'='guarantor', 'A121'='real estate',
                     'A122'='if not A121 : building society savings agreement/life insurance',
                     'A123'='if not A121/A122 : car or other, not in attribute 6',
                     'A124'='unknown / no property', 
                     'A141'='bank', 'A142'='stores',  'A143'='none', 'A151'='rent', 'A152'='own',
                     'A153'='for free', 'A171'='unemployed/ unskilled - non-resident',
                     'A172'='unskilled - resident', 'A173'='skilled employee / official',
                     'A174'='management/ self-employed/highly qualified employee/ officer',
                     'A191'='none', 'A192'='yes, registered under the customers name',
                     'A201'='yes', 'A202'='no')



german.data  <-  german.decode(german.data,german.codes)


# Graficar relación entre credit.history y good.loan

# visualización de credit.history
credit.history.df  <- german.data %>%
  group_by(credit.history) %>%
  summarise(count = n()) %>%
  arrange(desc(count))

g1  <- ggplot(credit.history.df, aes(x= reorder(credit.history,count), y=count)) + 
  geom_bar(stat="identity", fill="steelblue") + 
  coord_flip() + 
  theme(axis.text.y=element_text(size=rel(0.9)))

# visualizando good.loan

good.loan.df  <-  german.data %>%
  count(good.loan)

g2  <- ggplot(good.loan.df, aes(x= reorder(good.loan,n), y=n)) + 
  geom_bar(stat="identity", fill="steelblue")

# Visualización combinando las 2 variables

credit.good.loan  <- german.data %>%
  group_by(credit.history,good.loan) %>%
  summarise(count = n())

g3 <- ggplot(credit.good.loan, aes(x= reorder(credit.history,count), y=count, fill = good.loan)) + 
  geom_bar(stat="identity") + 
  coord_flip() + 
  theme(axis.text.y=element_text(size=rel(0.9)))

g4 <- ggplot(credit.good.loan, aes(x = reorder(credit.history,-count), y = count)) + 
  geom_bar(stat = "identity", fill = "steelblue") +
  facet_wrap(~ good.loan) +
  xlab("Historial de Crédito") + ylab("Numero de créditos") + 
  theme(axis.text.x = element_text(angle = 90,size=14))

g5 <- ggplot(credit.good.loan, aes(x = good.loan, y = count, color =credit.history, group=credit.history)) +
  geom_line()

########Variables faltantes

indicesConNAs <- function(data, porcentaje=0.2) {
  n <- if (porcentaje < 1) {
    as.integer(porcentaje  * ncol(data))
  } else {
    stop("Debes de introducir el porcentaje de columnas con NAs.")
  }
  indices <- which( apply(data, 1, function(x) sum(is.na(x))) > n )
  if (!length(indices)) {
    warning("No hay observaciones con tantos NAs 
            (la respuesta de la función es vacía),
            no se recomienda indexar el data.frame con esto")
  }
  indices
}



#####Si la variable es categórica

dataset$cat.with.NAs.fix <- ifelse(is.na(dataset$cat.with.NAs),
                                   "missing",
                                   ifelse(dataset$ccat.with.NAs == TRUE,    
                                          # o el valor que sea
                                          "level_1",
                                          "level_2"))

####Evaluación de modelos de probabilidad
library(ROCR,quietly = TRUE)
data(ROCR.simple)  # Datos de prueba

pred <- prediction(ROCR.simple$predictions, ROCR.simple$labels)
perf <- performance(pred, "tpr", "fpr")  # Graficamos ROC, este paquete permite muchas gráficas
plot(perf, colorize=TRUE)


############################################Mis funciones extras

##medias por filas=1 o columnas=2


medias.f.c<- function(x,p)
{ if(p==1) return (apply(x, 1, mean, na.rm = TRUE))
  else{
    if(p==2) return(apply(x, 2, mean, na.rm = TRUE))
    else return("1 ó 2")
  }
}


#############################################Data munging
############################################Feature Selection


##Filtrado basado en las propiedades de la distribución 
# low variability
low.variability  <- function(df)
{
  Q  <- apply(df, 2, FUN = quantile) # se obtienen cuantiles por variable
  RanIQ  <- apply(df,2,FUN=IQR) # se obtiene el rango intercuantile por variable
  Varia  <- RanIQ / (apply(df,2,FUN=max)- apply(df,2,FUN=min) ) *100 #% VARIABILIDAD
  res  <- round(rbind(Q,RanIQ,Varia),2)#redondeo a dos digitos
  res
}


# Correlation Filtering

correlation.filtering  <- function(df)
{
  require(corrplot)
  require(plotrix)
  cor  <-  cor(df,use="complete.obs")
  corrplot(cor,  main="Correlacion", method = c("ellipse"))
  cor
}



# Fast correlation-based filtering

FCB.filtering <- function(datos, variable, p)
{
  df <- as.data.frame(datos[which(sapply(datos, is.numeric))]) ##eleminamos variables no numericas
  y <- datos[,variable]
  corr <- abs(apply(df, 2, cor, y, use = "p"))##se obtiene vector de correlacion
  corr <- sort(corr[names(corr) != variable],decreasing=TRUE)
  vars.quitan <- character(length(corr))
  nvars.quitan <- numeric(length(corr))
  for (i in 1:length(corr)) 
  {if (corr[i] > p) vars.quitan[i] <- names(corr)[i] }
  return(vars.quitan)
}


#FCB.filtering(iris,"Sepal.Length",0.2)


# Forward selection

forward.filtering <- function(df, y)
{
  saturado <- paste(colnames(df), collapse="+")
  f<-step(lm(df[,y]~1,data=na.omit(df)),
          direction="forward", scope=paste("~",saturado),k=2)   #con k igual a 2 el criterio es AIC
  f
}


# Random Forest

library(randomForest)
rf <- randomForest(formula, df, importance=TRUE)
imp <- importance(rf)
rf.vars <- names(imp)[order(imp, decreasing=TRUE)[1:30]]
# Gráfica
varImpPlot(fmodel, type=1)




# Épsilon






####load data

library(stringr)

loadData <- function(name, full_path, ...) {
  
  if (exists(name))
    stop("Error: No se indica el nombre del data source (ds), el argumento 'name' está vacío.")
  
  if (exists(full_path))
    stop("Error: No se indica la ruta para el archivo que contiene el data source, el argumento 'full_path' está vacío")
  
  ds <- NULL
  
  name <- paste(name, ".rds", sep="")
  
  rds_path <- paste("../rds","/", name, sep="")
  
  if(file.exists(rds_path)) {
    cat("Buscando el RDS en ", rds_path, "\n")
    cat(system.time(ds <- readRDS(file = rds_path)), "\n")
  } else {
    cat("Buscando el archivo en ", full_path, "\n")
    cat(system.time(ds <- read.table(full_path, ...)), "\n")
    cat("Guardando el RDS en ", rds_path, "\n")
    cat(system.time(saveRDS(object = ds, file = rds_path)), "\n")
  }
  
  ## Predicciones
  
  
  predecirVariableCategorica <- function(outCol, varCol, appCol, pos) {
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
  
  
  ## Evaluación
  
  library(ROCR)
  
  calcAUC <- function(predcol, outcol) {
    perf <- performance(prediction(predcol, outcol == pos), 'auc')
    as.numeric(perf@y.values)
  }
  
  ds
}



