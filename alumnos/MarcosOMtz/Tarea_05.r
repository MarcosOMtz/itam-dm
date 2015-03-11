# === TAREA 05 ===
# Alumno: Marcos Olguin Martinez
# Modelado de datos


# Limpieza de objetos
rm(list=ls())
gc()


# Librerias
library(Hmisc)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(stringr)
library(party)
library(rpart)
library(randomForest)


# >>> 1.- Data set: Cargamos el archivo RData que generamos en el ejercicio anterior

source(file=".../lib/utils.r", chdir=TRUE)

(load("/Users/Marcos/itam-dm/data/KDD1998/clean/cup98lrn_141216.RData"))

# Visualizando resultados
length(vars.a.ignorar)
length(vars.input)


# >>> 2.- Semilla

# Generamos una secuencia aleatoria y seleccionamos una al azar como la semilla. As?? podremos repetir
# el an??lisis si lo deseamos
(seed <- sample(1:1000000, 1))


# Alternativamente, podemos establecer una semilla por default, por ejemplo:
seed <- 12345




# >>> 3.- Variable de Salida

# Para este estudio predeciremos la variable "target.d2"
ds <- as.data.frame(ds)
(outcome <- target[3])

# El costo de cada contacto es de $0.68 USD
cost <- 0.68




# >>> 4.- Prueba y Entrenamiento
train.size <- round(num.observaciones*0.7)
test.size <- num.observaciones - train.size

# Guardamos las columnas de salida
ds.targets <- ds[, target]
dim(ds.targets)

#Eliminamos las variables a ignorar
ds <- ds[, c(vars.input, outcome)]
dim(ds)




# >>> 5.- Feature Engineering

# Modelos

# Arbol de decision
# Usaremos para fines de ilustarcion, la funcion "rpart()" del paquete "party". Este arbol tiene los
# siguientes parametros:

# - Minsplit: Minimo numero de instancias en un nodo para considerar su division
# - MinBucket: Minimo numero de instancias en el nodo terminal
# - MaxSurrogate: Numero de splits a evaluar
# - MaxDepth: Controla la maxima profundidad del arbol


# Random Forest

# Seleccion de variables por Random Forest
# Probaremos con todas las variables
# Eliminamos las donaciones

ds.positive.complete <- ds[ds$target.d2 != "[0,0.1)", ]
summary(ds.positive.complete$target.d2) # Se excluyeron los registros de [0,0.1)

dim(ds.positive.complete)


# Se ha eliminado el factor o clase [0,0.1)
ds.positive.complete$target.d2 <- as.character(ds.positive.complete$target.d2)
ds.positive.complete$target.d2 <- as.factor(ds.positive.complete$target.d2)


# Se crean los datos de entrenamiento y prueba
train.idx <- sample (1:num.observaciones, train.size)
train <- ds[train.idx, ]
test <- ds[-train.idx, ]

train.targets <- ds.targets[train.idx, ]
test.targets <- ds.targets[-train.idx, ]

# Viendo resultados
head(train)


# Seleccionando variables importantes
(form.complete <- formula(paste(outcome, "~ ", paste(vars.input, collapse = ' + '), sep = '')))



# Feature selection con Random Forest
set.seed(123)
rf.complete <- randomForest(form.complete, train, importance=TRUE, na.action=na.omit)
imp.complete <- importance(rf.complete)
imp.complete <- as.data.frame(imp.complete)
rf.vars.complete <- rownames(imp.complete[with(imp.complete, order(-MeanDecreaseAccuracy)), ])
varImpPlot(rf.complete, type=1)



# Seleccionamos las 12 primeras variables.
# Ajustamos el modelo con RandomForest con variables seleccionadas por RandomForest

training.fs.complete <- train[, c(rf.vars.complete[1:12], outcome)]
testing.fs.complete <- test[, c(rf.vars.complete[1:12], outcome)]


form.complete <- formula(paste(outcome, "~ ", paste(rf.vars.complete[1:12], collapse = ' + '), sep=''))



# Aplicando randomforest del paquete randomforest. EXTRA: es mas rapido
training.fs.complete
form.complete
system.time(Ajuste2 <- randomForest(formula=form.complete,data=training.fs.complete,na.action=na.omit))
Ajuste2 # Viendo resultados del Random Forest

# Resultados:
# Call:
#      randomForest(formula = form.complete, data = training.fs.complete, na.action = na.omit) 
# Type of random forest: classification
# Number of trees: 500
# No. of variables tried at each split: 3
#
# OOB estimate of  error rate: 5.5%
# Confusion matrix:
#          [0,0.1) [0.1,10) [10,15) [15,20) [20,25) [25,30) [30,50) [50,200) class.error
# [0,0.1)    63100       31      48      55      63      32      18        8 0.004024939
# [0.1,10)     780        6       1       0       1       0       0        0 0.992385787
# [10,15)      974        1       2       0       2       0       0        0 0.997957099
# [15,20)      558        0       0       4       2       1       0        0 0.992920354
# [20,25)      537        1       2       2       2       0       0        0 0.996323529
# [25,30)      285        0       0       1       0       0       1        0 1.000000000
# [30,50)      184        0       0       0       0       1       0        0 1.000000000
# [50,200)      83        0       0       0       0       0       0        0 1.000000000





# FEATURE SELECCION tomando encuenta la correlacion

# En seleccion de variables con randomforest, castiga mucho la correlacion, por lo que si
# dos variables, aunque sean muy importantes al modelo, si hay correlacion las elimina
# Es una desventaja, por lo que se debe de analizar ambas posturas e investigar por criterio
# y con expertos


### correlacion caret packages

var.num  <- training.fs.complete[sapply(training.fs.complete, is.numeric)]

descrCor <- cor(var.num, use="complete")
summary(descrCor[upper.tri(descrCor)])
descrCor

# Nos quedaremos con las variables con una correlacion menor a 0.75
#           voc2        ic4        ic15        ic5         hv2        hc18        hur2         ic6  			 lfc5       ic16         dw2
#voc2  1.0000000  0.5156022 -0.46632945  0.2809440  0.21209511  0.27066633  0.74927568 -0.55620299	 0.45136929 -0.3380684  0.66951667
#ic4   0.5156022  1.0000000 -0.65458750  0.8808016  0.74183792 -0.13204200  0.61184117 -0.65449940	 0.34879069 -0.6447080  0.25069145
#ic15 -0.4663295 -0.6545875  1.00000000 -0.5089737 -0.39440409  0.08923121 -0.48405705  0.89660455	-0.36532148  0.4779406 -0.20600888
#ic5   0.2809440  0.8808016 -0.50897373  1.0000000  0.73952592 -0.15855439  0.39618051 -0.50414181	 0.18277173 -0.5082204  0.06354280
#hv2   0.2120951  0.7418379 -0.39440409  0.7395259  1.00000000 -0.18177002  0.22133426 -0.42683525	 0.17216888 -0.4585408 -0.03687023
#hc18  0.2706663 -0.1320420  0.08923121 -0.1585544 -0.18177002  1.00000000  0.08407383  0.07946014	-0.02540496  0.1461433  0.17536032
#hur2  0.7492757  0.6118412 -0.48405705  0.3961805  0.22133426  0.08407383  1.00000000 -0.54193205	 0.30186334 -0.4609903  0.73873376
#ic6  -0.5562030 -0.6544994  0.89660455 -0.5041418 -0.42683525  0.07946014 -0.54193205  1.00000000	-0.42793466  0.5578263 -0.25225069
#lfc5  0.4513693  0.3487907 -0.36532148  0.1827717  0.17216888 -0.02540496  0.30186334 -0.42793466	 1.00000000 -0.2409215  0.15176878
#ic16 -0.3380684 -0.6447080  0.47794062 -0.5082204 -0.45854085  0.14614335 -0.46099031  0.55782633	-0.24092154  1.0000000 -0.16597063
#dw2   0.6695167  0.2506914 -0.20600888  0.0635428 -0.03687023  0.17536032  0.73873376 -0.25225069	 0.15176878 -0.1659706  1.00000000


# Correlaciones mayores a 0.75:
# ic4 e ic5 tienen correlacion de 0.8808016
# ic6 e ic15 tienen correlacion de 0.89660455
# Por lo que eliminamos las variables ic4, ic5, ic6 e ic15


# Por lo que la formula queda de la siguiente manera:
vars <- c("voc2","hv2","hc18","hur2","lfc5","ic16","dw2")

(form.cor <- formula(paste(outcome, "~ ", paste(vars, collapse = ' + '), sep='')))


# Prueba.
training.fs.cor  <- train[,c(vars,outcome)]
testing.fs.cor  <- test[,c(vars,outcome)]

system.time(Ajuste3  <- randomForest(formula=form.cor,data=training.fs.cor,na.action=na.omit))
Ajuste3

# Resultados:
# Call:
#      randomForest(formula = form.cor, data = training.fs.cor, na.action = na.omit) 
# Type of random forest: classification
# Number of trees: 500
# No. of variables tried at each split: 2
#
# OOB estimate of  error rate: 6.49%
# Confusion matrix:
#          [0,0.1) [0.1,10) [10,15) [15,20) [20,25) [25,30) [30,50) [50,200) class.error
# [0,0.1)    62436      203     258     152     165      75      39       27  0.01450556
# [0.1,10)     777        5       1       1       3       0       1        0  0.99365482
# [10,15)      963        0       8       2       4       1       0        1  0.99182840
# [15,20)      553        2       3       2       2       2       1        0  0.99646018
# [20,25)      534        3       4       3       0       0       0        0  1.00000000
# [25,30)      284        0       1       2       0       0       0        0  1.00000000
# [30,50)      183        1       0       1       0       0       0        0  1.00000000
# [50,200)      82        0       1       0       0       0       0        0  1.00000000




# Aplicando la misma seleccion de variables con RandomForest y con Correlacion al algoritmo
# de Arbol de Decision


# Seleccion utilizando RandomForest
(form.complete <- formula(paste(outcome, "~ ", paste(rf.vars.complete[1:12], collapse = ' + '), sep='')))
# target.d2 ~ voc2 + ic4 + ic15 + ic5 + hv2 + hc18 + hur2 + ic6 + lfc5 + rfa.2 + ic16 + dw2


# Seleccion utilizando correlacion
(form.cor <- formula(paste(outcome, "~ ", paste(vars, collapse = ' + '), sep='')))
# target.d2 ~ voc2 + hv2 + hc18 + hur2 + lfc5 + ic16 + dw2





