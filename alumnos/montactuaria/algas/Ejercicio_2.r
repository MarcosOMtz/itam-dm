# limpieza. uso recomendado con regularidad
rm(list=ls()) # para limpiar el workspace
gc() # ir viendo estadísticas del uso de la memoria.


#carga de archivos a utilizar
source("0-load.r")
source("2-eda.r")
#source("utils.r")
library(corrgram)
library(plyr)

#asignación de datos
algas.data  <- load()
View(algas.data)

#Exploración general.

summary(algas.data)
str(algas.data)




#Ejemplo para visualizar al dataframe= algas.data, y 4 columnas de manera aleatoria.

eda1(algas.data,5)

#Ejemplo para visualizar al dataframe= algas.data, y 5 columnas indicadas (vector con el numero de las columnas).

eda1(algas.data,c(3,9,5,11,16))



#Ejemplo con el dataframe=algas.data, con la columna base V1, la cual es una
#variable categórica. y se compara contra todas las otras columnas.

eda2(algas.data,2)

eda2(algas.data,2,c(1,6,11,9,6))

#Ejemplo con el df=algas.data, con la columna base V6, la cual es una
#variable numérica. y se compara contra todas las otras columnas.

eda2(algas.data,4)

#Ejemplo con el dataframe=algas.data, con la columna base V6, la cual es una
#variable numérica. y se compara con ciertas columnas indicadas.

eda2(algas.data,6, c(4,3,12))


# visualización de NA`s

na_algas <- as.data.frame(abs(is.na(algas.data)))
sort(colSums(na_algas),decreasing=T)
sort(colMeans(na_algas*100),decreasing=T)

# Extrae las variables que tienen algunas celdas con NAs
y <- na_algas[which(sapply(na_algas, sd) > 0)] 

# Da la correación un valor alto positivo significa que desaparecen juntas.
cor(y)


# Grafico de correlación

corrgram(y, order=TRUE, lower.panel=panel.shade,
         upper.panel=panel.pie, text.panel=panel.txt,
         main="Datos numéricos sin NA`s de algas.data") 


# Visualizar variables faltantes

summary(algas.data[-grep(colnames(algas.data),pattern = "^a[1-9]")])

# visualizando y contando las lineas que se elimirán por no tener información completa
nrow(algas.data[!complete.cases(algas.data),])

algas.con.NAs <- algas.data[!complete.cases(algas.data),] # guardarlas

algas.con.NAs[c('mxPH', 'mnO2', 'Cl', 'NO3', 'NO4', 'oPO4', 'PO4', 'Chla')]

# si no podemos hacer observación visual se recomienda usar:

apply(algas.data, 1, function(x) sum(is.na(x))) # visualiza los NA`S por registro o fila

algas.data[apply(algas.data, 1, function(x) sum(is.na(x))) > 2,]

# Eliminado las observaciones con muchos NA`S


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




indicesConNAs(algas.data,0.2)

indicesConNAs(algas, 0.8)


# creando nuevo df para pruebas de la función de cambio NA`s
algas  <- algas.data

#agregando NA`s
algas[4,1] <- algas[1,1] <- NA


#probando mapvalues:

tab  <- table(algas$temporada)
idx  <- tab == max(tab)
max  <- names(tab)[idx]
max

mapvalues(algas$temporada,from=NA,to=max)

mapvalues(algas[,"Cl"],from=NA,to=mean(algas[,"Cl"],na.rm=T))
nuevo<- mapvalues(algas[,"mnO2"],from=NA,to=50)
mapvalues(algas[,"Cl"],from=NA,to=mean(algas[,"Cl"],na.rm=T))


#Creando función con mapvalues. 

imputarValorCentral <- function(data, colnames){
    for(n in colnames){
        if(class(data[,n])=="factor"){
                   tab  <- table(data[,n])
                   max  <- names(tab)[max(tab) == tab]
            data[,n]  <- mapvalues(data[,n], from = NA, to = max)
                   
            }
        else {
            me  <-  mean(data[,n],na.rm=TRUE)
            data[,n]  <- mapvalues(data[,n], from = NA, to = me)   
            }   
        }
}


#Creando función con ifelse:

str(algas.data)

#saveRDS(algas.data,file="algas.rds")

#algas  <-  readRDS("algas.rds")


#Validando con ifelse.
vec  <- ifelse(!is.na(algas[,"temporada"]),algas[,"temporada"],
               names(table(algas[,"temporada"]))[max(table(algas[,"temporada"])) == table(algas[,"temporada"])])

algas[,"temporada"]  <- mapvalues(vec,from=1:nlevels(algas[,"temporada"]), to=levels(algas[,"temporada"]))  


# creando función:

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


#Visualizando correlación rápidamente:

symnum(
    cor(algas[c('mxPH', 'mnO2', 'Cl', 'NO3', 'NO4', 'oPO4', 'PO4', 'Chla')], 
        use="complete.obs")
)


library(ggplot2)
ggplot(data=algas) + 
    aes(x=oPO4, y=PO4) + 
    geom_point(shape=1) + # Usamos una bolita para los puntos
    geom_smooth(method=lm, se=FALSE) 
# Mostramos la linea de la regresión y no mostramos la región de confianza


#Creando función que sustituya los NA`s por valore de la regresión lineal obtenida de la
#relación de 2 covariables con alta correlación.

algas <- algas[-indicesConNAs(algas),]
object <- lm(PO4 ~ oPO4, data=algas)
predict(object)

lm  <- predict(lm(PO4 ~ oPO4, data=algas))

#lm  <- predict(lm(PO4 ~ oPO4, data=algas))

# Función
imputarValorRegresion <- function(data, n,lm){

            data$n <-  ifelse(!is.na(data[,n]),data[,n],
                   lm)
        }
    



imputarValorRegresion(algas,"PO4",lm)


summary(algas)

algas$PO4 <-  ifelse(!is.na(algas[,"PO4"]),algas[,"PO4"],lm)
summary(algas)

# Función Variables faltantes por: Similitud. (bajo la exploración se hará bajo
# las observaciones "PO4" y "oPO4")

# Normalizar los valores numéricos antes de calcular las distancias. (normalizar o escalar ())

algas  <- algas.data
algas <- algas[-indicesConNAs(algas),]

algas$"PO4"  <- (algas$"PO4"-mean(algas$"PO4",na.rm=T))/sd(algas$"PO4",na.rm=T)

algas$"oPO4"  <-  (algas$oPO4 - mean(algas$oPO4,na.rm=T))/ sd(algas$oPO4,na.rm=T)


#Utilizando la distancia euclídea


d  <- sqrt(abs(sum(algas$"PO4"-algas$"oPO4",na.rm=T)))

#promedio con los pesos de los valores vecinos. peso = funcion gausiana

peso  <-  exp(-d)

peso

#Función

imputarSimilitud <- function(data, num_vecinos) { ... }


# Normalizar los nombres de las variables.
# ver el paquete library(rattle), su función nomVarNames

# Función:

normalizarNombres <- function(df.colnames) {

    require(stringr)
    
    
    df.colnames <- str_replace_all(df.colnames,"([[:punct:]])|\\s+",".")
    df.colnames <- gsub("([a-z])([A-Z])", "\\1.\\L\\2", df.colnames, 
                        perl = TRUE)
    df.colnames  <- sub("^(.[a-z])", "\\L\\1", df.colnames, perl = TRUE)
    df.colnames  <- tolower(df.colnames)
   }

col <-  c("Other installment plans","ThisText", "NextText", "DON'T_CHANGE",
                "Other debtors / guarantors")

col  <- normalizarNombres(col)

col
