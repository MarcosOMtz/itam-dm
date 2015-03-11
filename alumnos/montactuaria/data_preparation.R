
library(dplyr)
library(plyr)
library(ggplot2)
library(tidyr)
library(lattice)
library(scales)
library(Hmisc)
library(lubridate)
library(gridExtra)
library(ggthemes)
library(knitr)
library(car)
library(stringr)

source("utils.r", chdir = TRUE)

setwd()


ds.path <- "cup98lrn.txt" # Puede ser un URL o una dirección en el directorio

ds.name <- "cup98lrn" # Nombre de nuestro conjunto de datos, e.g. algas, german


datos <- read.table("C:/Users/Mont/itam-dm/alumnos/montactuaria/cup98lrn.txt", header=TRUE, sep=",")

saveRDS(datos,"ds.rds")

ds  <- readRDS("ds.rds")



dim(ds)


sapply(ds, class)

#Variables demográficas
describe(ds[,1:28])

#Número de veces que el donador respondió a otras campañas
describe(ds[,29:42])

#Overlay data (?)
describe(ds[,43:55])


##Intereses del donador
describe(ds[,56:74])


##Estatus PEP star RFA
describe(ds[,75])

##Características de la vecindad del donador

describe(ds[,76:361])


##Histórico de promociones

describe(ds[,362:407])

#Resúmen de variables del histórico de promociones

describe(ds[,408:412])


#Histórico de donativos

describe(ds[,413:456])

#Resúmen de variables del histórico de donativos

describe(ds[,457:469])

#ID y targets

describe(ds[,470:473])

#RFA

#RFA significa Recency/Frequency/Donation Amount

describe(ds[,474:479])


#Clúster y Geocode

describe(ds[,480:481])


#Descripción de las variables de salida

(porcentaje.respuesta.b <- round(100 * prop.table(table(ds$TARGET_B)), digits=1))

etiquetas <- paste("TARGET_B=", names(porcentaje.respuesta.b), "\n", porcentaje.respuesta.b, "%", sep=" ")

pie(porcentaje.respuesta.b, labels = etiquetas)

ds.positive <- ds[ds$TARGET_D >0, ]

target.d.positive <- ds.positive$TARGET_D

summary(target.d.positive)

donaciones.positivas <- length(target.d.positive)

boxplot(target.d.positive)


target.d.positive <- round(target.d.positive)


barplot(table(target.d.positive), las=2, cex.axis=0.8, cex.names=0.8)


ds$TARGET_D2 <- cut(ds$TARGET_D, right=FALSE, breaks=c(0,0.1, 10,15,20,25,30,50, max(ds$TARGET_D)))

ds.positive$TARGET_D2 <- cut(ds.positive$TARGET_D, right=FALSE, breaks=c(0,0.1, 10,15,20,25,30,50, max(ds.positive$TARGET_D)))


table(ds$TARGET_D2)

###normalizar nombres
normalizarNombres <- function(nombres) {
  
  # Convertimos a minúsculas
  nombres <- tolower(nombres)
  
  # Eliminamos '_' por '.'
  nombres <- str_replace_all(string = nombres, pattern = '_', replacement = '.')
  
}

names(ds) <- normalizarNombres(names(ds))

names(ds)


##clases

sapply(ds, class)


##identificacion variables

vars <- names(ds) # Guardamos los nombres de variables
target <- c("target.b", "target.d", "target.d2")  # Si el modelo es supervisado
risk <- NULL # Si se proveé, es la importancia de la observación respecto a la variable (es una variable de salida)
costo <- NULL # Costo de equivocarse en la predicción (Si se proveé) (es una variable de salida)
id <- "controln" # Armar una id con columnas, o seleccionar el id del dataset


##recodificacion

vars.input <- setdiff(vars, target)
idxs.input <- sapply(vars.input, function(x) which(x == names(ds)), USE.NAMES=FALSE)

idxs.numericas <- intersect(idxs.input, which(sapply(ds, is.numeric)))
vars.numericas <- names(ds)[idxs.numericas]

idxs.categoricas <- intersect(idxs.input, which(sapply(ds, is.factor)))
vars.categoricas <- names(ds)[idxs.categoricas]


#variables a ignorar

vars.a.ignorar <- union(union(id, if (exists("risk")) risk), if(exists("cost")) cost)




# Ignoramos las que tengan un único valor por cada observación, pueden ser IDs
# IMPORTANTE: Esto puede eliminar fechas, ver sección anterior

ids <- names(which(sapply(ds, function(x) length(unique(x)) == nrow(ds))))

# Ignoramos los factores que tengan muchos niveles
# IMPORTANTE: ver sección anterior


factors <- which(sapply(ds[vars], is.factor))

niveles <- sapply(factors, function(x) length(levels(ds[[x]])))

(muchos.niveles <- names(which(niveles > 32)))

vars.a.ignorar <- union(vars.a.ignorar, muchos.niveles)

# Constantes
constantes <- names(which(sapply(ds[vars], function(x) all(x == x[1L]))))

vars.a.ignorar <- union(vars.a.ignorar, c(ids, constantes))


####faltantes

# Las que sean puros NAs
ids.nas.count <- sapply(ds[vars], function(x) sum(is.na(x)))
ids.nas <- names(which(ids.nas.count == nrow(ds)))

vars.a.ignorar <- union(ids.nas, vars.a.ignorar)


# Las que tengan muchos NAs (un 70% o más)
ids.many.nas <- names(which(ids.nas.count >= 0.7*nrow(ds)))

vars.a.ignorar <- union(ids.many.nas, vars.a.ignorar)

length(vars.a.ignorar)

vars.a.ignorar


##Variable de salida

dim(ds)
ds <- ds[!is.na(ds[target[1]]),]
ds <- ds[!is.na(ds[target[2]]),]
dim(ds)


###si el problema es de clasificacion

sapply(ds[,target], class)


ds[target[1]] <- as.factor(ds[[target[1]]])
table(ds[target[1]])
sapply(ds[,target], class)

##balance de ds
ggplot(data=ds, aes_string(x=target[1])) + geom_bar(width=0.3)


###variables correlacionadas

(system.time(vars.cor <- cor(ds[which(sapply(ds, is.numeric))], use="pairwise.complete.obs")))

vars.cor[upper.tri(vars.cor, diag=TRUE)] <- NA


vars.cor <- vars.cor                                  %>%
  abs()                                     %>%   
  data.frame()                              %>%
  mutate(var1=row.names(vars.cor))          %>%
  gather(var2, cor, -var1)                  %>%
  na.omit()

vars.cor <- vars.cor[order(-abs(vars.cor$cor)), ]

if (!file.exists("output")) dir.create("output") # Creamos la carpeta output, si no existe

# Guardar a CSV para tenerlo como respaldo
write.csv(vars.cor, "output/absolute_correlation.csv", row.names=FALSE)

(muy.cor <- filter(vars.cor, cor > 0.95)) # Mostramos las que tengan más del 95% de correlación

# Habría que decidir si se remueven y cuales se remueven (var1 o var2)
vars.a.ignorar <- union(vars.a.ignorar, muy.cor$var2)


#Para variables categóricas medimos su asociación con una prueba $\chi$-cuadrada

pruebaChiCuadrada <- function(var1, var2) {
  tabla <- table(var1, var2)
  
  plot(tabla, main=var1, las=1)
  
  print(var1)
  
  print(chisq.test(tabla))
}

sapply(names(which(sapply(ds.positive, is.factor))), pruebaChiCuadrada, var2=ds$target.d2)


##valores faltantes

observaciones.omitidas <- NULL

if (!file.exists("output")) dir.create("output") # Creamos la carpeta clean, si no existe

if(exists("observaciones.omitidas")) {
  write.csv(observaciones.omitidas, "output/observaciones_omitidas.csv", row.names=FALSE)
}

###Normalizar niveles

factors <- which(sapply(ds[vars], is.factor))

for (f in factors) levels(ds[[f]]) <- normalizarNombres(levels(ds[[f]]))

# Removemos las variables
vars <- setdiff(vars, vars.a.ignorar)


##Variables independientes

(vars.input <- setdiff(vars, target))

idxs.input <- sapply(vars.input, function(x) which(x == names(ds)), USE.NAMES=FALSE)

###var numericas

idxs.numericas <- intersect(idxs.input, which(sapply(ds, is.numeric)))

(vars.numericas <- names(ds)[idxs.numericas])


##categoricas

idxs.categoricas <- intersect(idxs.input, which(sapply(ds, is.factor)))

(vars.categoricas <- names(ds)[idxs.categoricas])

# Por conveniencia guardamos el número de observaciones supervivientes
num.observaciones <- nrow(ds)


target


# Guardamos todo en la carpeta 

ds.date <- paste0("_", format(Sys.Date(), "%y%m%d"))

ds.rdata <- paste0(ds.name, ds.date, ".RData") # Guardamos todo en un RData para poder automatizar el modelado

if (!file.exists("clean")) dir.create("clean") # Creamos la carpeta clean, si no existe

save(ds, ds.name, ds.path, ds.date, target, risk, costo, 
     id, vars.a.ignorar, vars, num.observaciones, 
     vars.input, idxs.input,
     observaciones.omitidas,
     vars.categoricas, idxs.categoricas,
     file=paste0("clean", "/", ds.rdata)
)


sessionInfo()

