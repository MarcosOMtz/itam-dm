# === TAREA 4 ===
# Alumno: Marcos Olguin Martinez
# Preparacion de datos


# Liempieza de objetos
rm(list=ls())
gc()



# Preparacion de los datos

library(Hmisc)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(stringr)


# >>> 1.- CARGAMOS LA BASE DE DATOS
# Cuando se trabaja en Windows
#ds <- read.table("D:/cup98lrn.txt", head=TRUE, sep=',', na.string=c('NA',''))
# Cuando se trabaja en Mac
ds <- read.table("/Users/Marcos/itam-dm/data/KDD1998/cup98lrn.txt", head=TRUE, sep=',', na.string=c('NA',''))

loadData <- function(name, full_path, ...) {
    
  if (exists(name))
    stop("Error: No se indica el nombre del data source (ds), el argumento 'name' est?? vac??o.")
  
  if (exists(full_path))
    stop("Error: No se indica la ruta para el archivo que contiene el data source, el argumento 'full_path' est?? vac??o")
  
  ds <- NULL
  name <- paste(name, ".rds", sep="")
  
  rds_path <- paste("/Users/Marcos/itam-dm/data/KDD1998","/", name, sep="")
  
  if(file.exists(rds_path)) {
    cat("Buscando el RDS en ", rds_path, "\n")
    cat(system.time(ds <- readRDS(file = rds_path)), "\n")
  } else {
    cat("Buscando el archivo en ", full_path, "\n")
    cat(system.time(ds <- read.table(full_path, ...)), "\n")
    cat("Guardando el RDS en ", rds_path, "\n")
    cat(system.time(saveRDS(object = ds, file = rds_path)), "\n")
  }
  ds
}


dim(ds)  # Para saber cuantos registros tenemos en la base de datos
describe(ds)  # Explora la base
summary(ds)   # Explora la base
str(ds)

ds <- tbl_df(ds) # Para obtener un print mejorado

sapply(ds, class)  # Estructura de la base de datos



# >>> 2.- SUMARIO ESTADISTICO

# Variables demograficas
describe(ds[,1:28])
# Numero de veces que el donador respondio a otras campa??as
describe(ds[,29:42])
# Overlay data
describe(ds[,43:55])
# Intereses del donador
describe(ds[,56:74])
# Estatus PEP star RFA
describe(ds[,75])
# Caracteristicas de la vecindad del donador
describe(ds[,76:361])
# Historico de promociones
describe(ds[,362:407])
# Resumen de variables del historico de promociones
describe(ds[,408:412])
# Historico de donativos
describe(ds[,413:456])
# Resumen de variables del historico de donativos
describe(ds[,457:469])
# ID y Targets
describe(ds[,470:473])
# RFA, Recency/Frequency/Donation Amount
describe(ds[,474:479])
# Cluster y Geocode
describe(ds[,480:481])



# >>> 3.- DESCRIPCION DE LA VARIABLE DE SALIDA
(porcentaje.respuesta.b <- round(100*prop.table(table(ds$TARGET_B)), digits=1))
etiquetas <- paste("TARGET_B=", names(porcentaje.respuesta.b), "\n", porcentaje.respuesta.b, "%", sep=" ")
pie(porcentaje.respuesta.b, labels=etiquetas)


ds.positive <- ds[ds$TARGET_D > 0, ]
target.d.positive <- ds.positive$TARGET_D
summary(target.d.positive)


donaciones.positivas <- length(target.d.positive)
donaciones.positivas

# Las donaciones positivas son r donaciones positivas y estan distribuidas asi:
boxplot(target.d.positive)

# Si vemos aquellas que fueron mayores a 1 USD (es decir, no fueron centavos) tenemos que restarle asi:
sum(!(target.d.positive %in% 1:200))

barplot(table(target.d.positive), las=2, cex.axis=0.8, cex.names=0.8)

# De acuerdo con la grafica anterior, discretizamos TARGET_D como sigue:
ds$TARGET_D2 <- cut(ds$TARGET_D, right=FALSE, breaks=c(0,0.1,10,15,20,25,30,50, max(ds.positive$TARGET_D)))
table(ds$TARGET_D2)



# >>> 4.- LIMPIEZA DE METADATOS
normalizarNombres <- function(nombres){
  #convertimos a minusculas
  nombres <- tolower(nombres)
  #eliminamos "_" por "."
  nombres <- str_replace_all(string=nombres, pattern='_', replacement='.')
}


names(ds) <- normalizarNombres(names(ds))



# >>> 5.- AJUSTE DE FORMATOS
sapply(ds, class)



# >>> 6.- TRANSFORMACION DE VARIABLES
# En esta seccion incluimos la tranformacion de las variables (normalizacion, estandarizacion, binning,
# log, etc.)



# >>> 7.- IDENTIFICACION DE VARIABLES
vars <- names(ds) #guardamos los nombres de las variables

target <- c("target.b","target.d","target.d2") # Si el modelo es supervizado
risk <- NULL  # Si se provee, es la importancia de la observacion respecto a la variable (es una variable de salida)
costo <- NULL # Costo de equivocarse en la prediccion (Si se provee) (es una variable de salida)
id <- "controln"  # Armar una ID con columnas, o seleccionar el ID del dataset



# >>> 8.- RECODIFICACION
# Random Forest no soporta variables categoricas con mas de 32 niveles
# Se recomienda agrupar las fechas por mes, dia de la semana, temporada, etc.
vars.input <- setdiff(vars, target)
idxs.input <- sapply(vars.input, function(x) which(x == names(ds)), USE.NAMES=FALSE)

idxs.numericas <- intersect(idxs.input, which(sapply(ds, is.numeric)))
vars.numericas <- names(ds)[idxs.numericas]

idxs.categoricas <- intersect(idxs.input, which(sapply(ds, is.factor)))
vars.categoricas <- names(ds)[idxs.categoricas]


vars.input


# >>> 9.- VARIABLES A IGNORAR
vars.a.ignorar <- union(union(id, if(exists("risk")) risk), if(exists("cost")) cost)



# >>> 10.- CONSTANTES Y VALORES UNICOS POR OBSERVACION
# Ignoramos las que tengan un unico valor por cada observacion, puede ser IDs
# IMPORTANTE: Esto puede eliminar fechas, ver seccion anterior

ids <- names(which(sapply(ds, function(x) length(unique(x)) == nrow(ds))))

# Ignoramos los factores que tengan muchos niveles
# IMPORTANTE: Ver seccion anterior

factors <- which(sapply(ds[vars], is.factor))
niveles <- sapply(factors, function(x) length(levels(ds[[x]])))
(muchos.niveles <- names(which(niveles > 32)))
factors  #Para ver la informacion generada
niveles  #Para ver la informacion generada

vars.a.ignorar
vars.a.ignorar <- union(vars.a.ignorar, muchos.niveles)
vars.a.ignorar #Para ver la informacion generada


# Constantes
constantes <- names(which(sapply(ds[vars], function(x) all(x == x[1L]))))

vars.a.ignorar <- union(vars.a.ignorar, c(ids, constantes))
vars.a.ignorar #Para ver la informacion generada


# Faltantes
# Las que sean puros NAs
ids.nas.count <- sapply(ds[vars], function(x) sum(is.na(x)))
ids.nas <- names(which(ids.nas.count == nrow(ds)))

ids.nas.count  #Para ver la informacion generada
ids.nas        #Para ver la informacion generada


vars.a.ignorar <- union(ids.nas, vars.a.ignorar)
vars.a.ignorar #Para ver la informacion generada


# Las que tengan muchos NAs
ids.many.nas <- names(which(ids.nas.count >= 0.7*nrow(ds)))
ids.many.nas   #Para ver la informacion generada

vars.a.ignorar <- union(ids.many.nas, vars.a.ignorar)
vars.a.ignorar #Para ver la informacion generada



# >>> 11.- VARIABLES DE SALIDA (TARGET)
dim(ds)
ds <- ds[!is.na(ds[target[1]]),]
ds <- ds[!is.na(ds[target[2]]),]
dim(ds)


# Si el problema es de clasificacion, hay que convertir la variable "target" a categorica
sapply(ds[,target], class)

ds[target[1]] <- as.factor(ds[[target[1]]])
table(ds[target[1]])

sapply(ds[,target], class)

# Esto nos mostrara la distribucion (indicara si el problema no esta balanceado)
ggplot(data=ds, aes_string(x=target[1])) + geom_bar(width=0.3)



# >>> 12.- VARIABLES CORRELACIONADAS
(system.time(vars.cor <- cor(ds[which(sapply(ds, is.numeric))], use="pairwise.complete.obs")))
# Me sale una alerta de que la Desviacion Estandar es CERO


vars.cor[upper.tri(vars.cor, diag=TRUE)] <- NA

vars.cor <- vars.cor                         %>%
            abs()                            %>%
            data.frame()                     %>%
            mutate(var1=row.names(vars.cor)) %>%
            gather(var2, cor, -var1)         %>%
            na.omit()

vars.cor <- vars.cor[order(-abs(vars.cor$cor)), ]


# Creamos la carpeta "output" si no existe
#if (!file.exists("output")) dir.create("output")
if (!file.exists("/Users/Marcos/itam-dm/data/KDD1998/output")) dir.create("/Users/Marcos/itam-dm/data/KDD1998/output")


#Guardar CSV para tenerlo como respaldo
write.csv(vars.cor, "/Users/Marcos/itam-dm/data/KDD1998/output/absolute_correlation.csv", row.names=FALSE)

(muy.cor <- filter(vars.cor, cor > 0.95)) #Mostramos las que tengan mas del 95% de correlacion


#Habria que decidir si se remueven y cuales se remueven (var1 o var2)
vars.a.ignorar <- union(vars.a.ignorar, muy.cor$var2)
vars.a.ignorar


# Para variables categoricas medimos su asociacion con una prueba "Chi-Cuadrada"
pruebaChiCuadrada <- function(var1, var2) {
  tabla <- table(var1, var2)
  plot(tabla, main=var1, las=1)
  print(var1)
  print(chisq.test(tabla))
}


sapply(names(which(sapply(ds.positive, is.factor))), pruebaChiCuadrada, var2=ds$target.d2)
# Envia una alerta de que todos los argumentos deben tener la misma longitud



# >>> 13.- VALORES FALTANTES
# Guardar las observaciones a omitir
write.csv(vars.a.ignorar, "/Users/Marcos/itam-dm/data/KDD1998/output/variables_a_ignorar.csv", row.names=FALSE)

# Las observaciones a omitir las guardamos como sigue:
observaciones.omitidas <- NULL

if (!file.exists("/Users/Marcos/itam-dm/data/KDD1998/output")) dir.create("/Users/Marcos/itam-dm/data/KDD1998/output") 

if (exists("observaciones.omitidas")) {
  write.csv(observaciones.omitidas, "/Users/Marcos/itam-dm/data/KDD1998/output/observaciones.omitidas.csv", row.names=FALSE)
}



# >>> 14.- NORMALIZAR NIVELES

# Removemos espacios, puntuaciones, camelCase, etc. en los niveles de los factores supervivientes
factors <- which(sapply(ds[vars], is.factor))
for (f in factors) levels(ds[[f]]) <- normalizarNombres(levels(ds[[f]]))

# Removemos las variables
vars <- setdiff(vars, vars.a.ignorar)
length(vars)



# >>> 15.- IDENTIFICACION DE NIVELES

# Variables independientes
(vars.input <- setdiff(vars, target))
idxs.input <- sapply(vars.input, function(x) which(x == names(ds)), USE.NAMES=FALSE)


# Varables numericas
idxs.numericas <- intersect(idxs.input, which(sapply(ds, is.numeric)))
(vars.numericas <- names(ds)[idxs.numericas])


# Variables categoricas
idxs.categoricas <- intersect(idxs.input, which(sapply(ds, is.factor)))
(vars.categoricas <- names(ds)[idxs.categoricas])


# Por convebiencia, guardamos el numero de observaciones supervivientes
num.observaciones <- nrow(ds)
num.observaciones


# Variables Target
target


# Guardamos todo en la carpeta
ds.date <- paste0("_", format(Sys.Date(), "%y%m%d"))
ds.name <- "cup98lrn"
ds.path <- "/Users/Marcos/itam-dm/data/KDD1998/cup98lrn.txt"
ds.rdata <- paste0(ds.name, ds.date, ".RData") # Guardamos todo en RData para poder automatizar el modelado


# Creamos la carpeta clean si no existe
if (!file.exists("/Users/Marcos/itam-dm/data/KDD1998/clean")) dir.create("/Users/Marcos/itam-dm/data/KDD1998/clean")


save(ds, ds.name, ds.path, ds.date, target, risk, costo, id, vars.a.ignorar, vars,
     num.observaciones, vars.input, idxs.input, observaciones.omitidas, vars.categoricas,
     idxs.categoricas, file=paste0("/Users/Marcos/itam-dm/data/KDD1998/clean", "/", ds.rdata))


sessionInfo()


# >>> 16.- TAREA
# Convertir fecha en categorica: viejo, mediano, nuevo
ds$fecha = as.POSIXlt(ds$odatedw*86400,origin="1970-01-01 00:00.00", tz="GMT")
ds$year = year(ds$fecha)
(cortes <- quantile(ds$fecha, c(0, 0.33,0.66,1)))
ds$antiguedad <- cut(ds$fecha, breaks = cortes, labels = c('viejo','mediano','nuevo'))

# Visualizar resultados
head(ds$antiguedad)


# Pasar el codigo postal a Estado
zipcodes <- read.csv('zip_code_database.csv', header = TRUE, fill=TRUE)
zipcodes$zip <- as.character(zipcodes$zip)


arregla_zip <- function(zip){
  if(nchar(zip)<4){
    return(paste('00',zip,sep=''))
    }else{
      if(nchar(zip)==4){
        return(paste('0',zip,sep=''))
        }else{
          return(zip)
          }
      }
  }

ds$zip <- apply(as.data.frame(ds$zip), 1, arregla_zip)
zipcodes <- zipcodes %>% select(zip,primary_city,state,latitude,longitude)
ds <- merge(ds,zipcodes,by='zip')


# Categoricas a numericas
vars.categoricas

categoricas.a.numericas <- function(ds,vars.categoricas) {
  for (var in vars.categoricas) {
    tab <- prop.table(table(ds[,var]))
    noms <- names(tab)
    props <- as.numeric(tab)
    cambia <- function(x) {
      ind = which(noms == x)
      return(props[ind])
    }
    ds[,paste(var,'.num',sep='')] <- apply(as.data.frame(ds[,var]),1,cambia)
  }
  return(ds)
}

ds <- categoricas.a.numericas(ds,vars.categoricas)



# Eliminar variables demasiado desbalanceadas
muy_desbalanceado <- function(ds, vars.categoricas, max.prop = 0.9) {
  vars.a.ignorar <- c()
  for (var in vars.categoricas) {
    tab <- prop.table(table(ds[,var]))
    if (max(tab) > max.prop) {
      vars.a.ignorar <- c(vars.a.ignorar, var)
    }
  }
  return(vars.a.ignorar)
}

vars.a.ignorar.2 <- muy_desbalanceado(ds,vars.categoricas,0.95)
vars.a.ignorar.2 

