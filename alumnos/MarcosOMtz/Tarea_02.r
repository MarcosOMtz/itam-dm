# === TAREA 02 ===
# Exploracion
source("0_load.r")
source("1_eda.r")

# Exploracion general de 5 variables
algas.data <- load()
eda1(algas.data, c(3,9,5,11,16))


# Exploracion general, tomando como base a comparar good.loan
eda2(algas.data, 2, c(1,6,11,9,6))


# Limpieza, uso recomendado con regularidad
rm(list=ls()) # para limpiar el workspace
gc()          # para ir viendo estadisticas en el uso de la memoria


# Carga de archivos a utilizar
source("0_load.r")
source("2_eda.r")
library(corrgram)
library(plyr)


# Asignacion de datos
algas.data <- load()
View(algas.data)   #llama la tabla de datos


# Exploracion general
summary(algas.data)
str(algas.data)


# Ejemplo para visualizar el dataframe (algas.data) y 4 columnas de manera aleatoria
eda1(algas.data, 5)


# Ejemplo para visualizar el dataframe (algas.data) y 5 columnas indicadas mediante un vector
eda1(algas.data, c(3,9,5,11,16))


#Ejemplo con el dataframe=algas.data, con la columna base V1, la cual es una
#variable categorica, y se compara contra todas las otras columnas
eda2(algas.data,1)
eda2(algas.data,1,c(1,6,11,9,6))


#Ejemplo con el dataframe (algas.data) con la columna base V6, la cual es una
#variable numerica, y se compara contra todas las otras columnas
eda2(algas.data,6)


#Ejemplo con el dataframe=algas.data, con la columna base V6, la cual es una
#variable num??rica. y se compara con ciertas columnas indicadas.
eda2(algas.data,6, c(4,3,12))


# Visualizacion de NA's
na_algas <- as.data.frame(abs(is.na(algas.data)))
sort(colSums(na_algas), decreasing=TRUE)       # Cantidad de NA's por columna
sort(colMeans(na_algas*100), decreasing=TRUE)  # Porcentaje de NA's por columna


# Extrae las variables que tienen algunas celdas con NA's
y <- na_algas[which(sapply(na_algas, sd) > 0)]


# Da la correlacion un valor alto positivo, significa que desaparecen juntas
cor(y)


# Grafico de correlacion
corrgram(y, order=TRUE, lower.panel=panel.shade, upper.panel=panel.pie,
         text.panel=panel.txt, main='Datos numericos sin NAs en algas.data')


# Visualizar variables faltantes
summary(algas.data[-grep(colnames(algas.data), pattern="^a[1-9]")])


# Visualizando y contando las lineas que se eliminaran por no tener informacion completa
nrow(algas.data[!complete.cases(algas.data),])

algas.con.NAs <- algas.data[!complete.cases(algas.data),] # guardarlas
algas.con.NAs[c('mxPH', 'mnO2', 'Cl', 'NO3', 'NO4', 'oPO4', 'PO4', 'Chla')]


# Si no podemos hacer observacion visual se recomienda usar:
# Se hace el conteo de NA's por fila
apply(algas.data, 1, function(x) sum(is.na(x)))

algas.data[apply(algas.data, 1, function(x) sum(is.na(x))) > 2,]


# Eliminado las observaciones con muchos NA's
indicesConNAs <- function(data, porcentaje=0.2){
  n <- if (porcentaje < 1){
    as.integer(porcentaje * ncol(data))
  }
  else {
    stop("Introducir el porcentaje de columnas con NA")
  }
  indices <- which(apply(data, 1, function(x) sum(is.na(x))) > n)
  if (!length(indices)) {
    warning("No hay suficientes NAs en las observaciones")
  }
  indices
}


indicesConNAs(algas.data, 0.2)
indicesConNAs(algas.data, 0.8)


# Creando nuevo df para pruebas de la funcion de cambio NA's
algas <- algas.data


# Agregando NA's
algas[4,1] <- algas[1,1] <- NA


# Se prueban los mapvalues
tab <- table(algas$temporada)
idx <- tab == max(tab)
max <- names(tab)[idx]
max


mapvalues(algas$temporada, from=NA, to=max)

mapvalues(algas[,"Cl"], from=NA, to=mean(algas[,"Cl"], na.rm=T))
nuevo <- mapvalues(algas[,"mnO2"], from=NA, to=50)
mapvalues(algas[,"Cl"], from=NA, to=mean(algas[,"Cl"], na.rm=T))


# Creando funcion con mapvalues
imputarValorCentral <- function(data, colnames) {
  for (n in colnames){
    if (class(data[,n]) == "factor"){
      tab <- table(data[,n])
      max <- names(tab)[max(tab) == tab]
      data[,n] <- mapvalues(data[,n], from=NA, to=max)
    }
    else {
      me <- mean(data[,n], na.rm=TRUE)
      data[,n] <- mapvalues(data[,n], from=NA, to=me)
    }
  }
}



# Creando funcion con ifelse:
str(algas.data)

#saveRDS(algas.data,file="algas.rds")
#algas  <-  readRDS("algas.rds")


#Validando con ifelse.
vec  <- ifelse(!is.na(algas[,"temporada"]),algas[,"temporada"],
               names(table(algas[,"temporada"]))[max(table(algas[,"temporada"])) == table(algas[,"temporada"])])

algas[,"temporada"]  <- mapvalues(vec,from=1:nlevels(algas[,"temporada"]), to=levels(algas[,"temporada"]))  


# Creando funcion:
imputarValorCentral <- function(data, colnames){
  for(n in colnames){
    if(class(data[,n])=="factor"){
      
      vec  <- ifelse(!is.na(data[,n]),data[,n],
                     names(table(data[,n]))[max(table(data[,n])) == table(data[,n])])
      
      data[,n]   <-  mapvalues(vec,from=1:nlevels(data[,n]), to=levels(data[,n]))  
    }
    else{
      data[,n]   <-  ifelse(!is.na(data[,n]),data[,n],mean(data[,n],na.rm=T))
      
    }
  }
}


imputarValorCentral(algas,c("mxPH","mnO2","Cl","Chla")
                    
                    
#Visualizando correlaci??n r??pidamente:
                  
symnum(
  cor(algas[c('mxPH', 'mnO2', 'Cl', 'NO3', 'NO4', 'oPO4', 'PO4', 'Chla')],use="complete.obs")
  )
                    
                    
library(ggplot2)
ggplot(data=algas) +
  aes(x=oPO4, y=PO4) +
  geom_point(shape=1) + # Usamos una bolita para los puntos
  geom_smooth(method=lm, se=FALSE)
              # Mostramos la linea de la regresi??n y no mostramos la regi??n de confianza
              #Creando funci??n que sustituya los NA`s por valore de la regresi??n lineal obtenida de la
              #relaci??n de 2 covariables con alta correlaci??n.
                    
algas <- algas[-indicesConNAs(algas),]
object <- lm(PO4 ~ oPO4, data=algas)
predict(object)
                    
lm  <- predict(lm(PO4 ~ oPO4, data=algas))


# Funcion
imputarValorRegresion <- function(data, n,lm){
  data$n <-  ifelse(!is.na(data[,n]),data[,n],lm)
}



imputarValorRegresion(algas,"PO4",lm)


summary(algas)


algas$PO4 <- ifelse(!is.na(algas[,"PO4"]),algas[,"PO4"],lm)
summary(algas)


# Funcion Variables faltantes por: Similitud. (bajo la exploracion se hara bajo
# las observaciones "PO4" y "oPO4")
# Normalizar los valores num??ricos antes de calcular las distancias. (normalizar o escalar ())
algas  <- algas.data
algas <- algas[-indicesConNAs(algas),]
                    
algas$"PO4"  <- (algas$"PO4"-mean(algas$"PO4",na.rm=T))/sd(algas$"PO4",na.rm=T)

algas$"oPO4"  <-  (algas$oPO4 - mean(algas$oPO4,na.rm=T))/ sd(algas$oPO4,na.rm=T)


#Utilizando la distancia eucl??dea
d  <- sqrt(abs(sum(algas$"PO4"-algas$"oPO4",na.rm=T)))


#promedio con los pesos de los valores vecinos. peso = funcion gausiana
peso  <-  exp(-d)
peso

#Funci??n
imputarSimilitud <- function(data, num_vecinos) { ... }


# Normalizar los nombres de las variables.
# ver el paquete library(rattle), su funcion nomVarNames

# Funci??n:

normalizarNombres <- function(df.colnames) {

require(stringr)

df.colnames <- str_replace_all(df.colnames,"([[:punct:]])|\\s+",".")
df.colnames <- gsub("([a-z])([A-Z])", "\\1.\\L\\2", df.colnames, perl = TRUE)
df.colnames  <- sub("^(.[a-z])", "\\L\\1", df.colnames, perl = TRUE)
df.colnames  <- tolower(df.colnames)
}

col <-  c("Other installment plans","ThisText", "NextText", "DON'T_CHANGE",
          "Other debtors / guarantors")

col  <- normalizarNombres(col)
col






ds$"PO4" <- (ds$"PO4"-mean(ds$"PO4",na.rm=T)) / sd(ds$"PO4",na.rm=T)
ds$"oPO4" <- (ds$oPO4 - mean(ds$oPO4,na.rm=T)) / sd(ds$oPO4,na.rm=T)
ds$"mxPH" <- (ds$"mxPH"-mean(ds$"mxPH",na.rm=T)) / sd(ds$"mxPH",na.rm=T)
ds$"mnO2" <- (ds$mnO2 - mean(ds$mnO2 ,na.rm=T)) / sd(ds$mnO2 ,na.rm=T)

ds$Cl <- (ds$Cl-mean(ds$Cl,na.rm=T)) / sd(ds$Cl,na.rm=T)
ds$NO3 <- (ds$NO3 - mean(ds$NO3,na.rm=T)) / sd(ds$NO3,na.rm=T)
ds$NO4 <- (ds$NO4 -mean(ds$NO4,na.rm=T)) / sd(ds$NO4,na.rm=T)
ds$Chla <- (ds$Chla - mean(ds$Chla ,na.rm=T)) / sd(ds$Chla ,na.rm=T)

ds$a1 <- (ds$a1-mean(ds$a1,na.rm=T)) / sd(ds$a1,na.rm=T)
ds$a2 <- (ds$a2 - mean(ds$a2,na.rm=T)) / sd(ds$a2,na.rm=T)
ds$a3 <- (ds$a3 -mean(ds$a3,na.rm=T)) / sd(ds$a3,na.rm=T)
ds$a4 <- (ds$a4 - mean(ds$a4,na.rm=T)) / sd(ds$a4 ,na.rm=T)
ds$a5 <- (ds$a5 - mean(ds$a5,na.rm=T)) / sd(ds$a5,na.rm=T)
ds$a6 <- (ds$a6 -mean(ds$a6,na.rm=T)) / sd(ds$a6,na.rm=T)
ds$a7 <- (ds$a7 - mean(ds$a7,na.rm=T)) / sd(ds$a7,na.rm=T)


# Cambio de NA por mean
ds$"mxPH" <- ifelse(!is.na(ds$"mxPH"),ds$"mxPH",mean(ds$"mxPH",na.rm=T))
ds$"mnO2" <- ifelse(!is.na(ds$"mnO2"),ds$"mnO2",mean(ds$"mnO2",na.rm=T))

ds$"Cl" <- ifelse(!is.na(ds$"Cl"),ds$"Cl",mean(ds$"Cl",na.rm=T))
ds$"Chla" <- ifelse(!is.na(ds$"Chla"),ds$"Chla",mean(ds$"Chla",na.rm=T))                    





