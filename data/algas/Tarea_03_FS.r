# Minería y Análisis de Datos
# === TAREA 02 ===


# Funcion 1; paso 1) Cargamos la base de datos de Algas.
load <- function()
{
  if (file.exists('algas.txt'))
  {
    algas <- read.table("algas.txt", header=FALSE, dec=".",
                        col.names=c('temporada', 'tama??o', 'velocidad', 'mxPH',
                                    'mnO2', 'Cl', 'NO3', 'NO4', 'oPO4', 'PO4',
                                    'Chla', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6',
                                    'a7'),
                        na.strings="XXXXXXX")
  }
  else
  {
    algas <- read.table(file="/Users/Marcos/itam-dm/data/algas/algas.txt",
                        header=FALSE, dec=".",
                        col.names=c('temporada', 'tama??o', 'velocidad', 'mxPH',
                                    'mnO2', 'Cl', 'NO3', 'NO4', 'oPO4', 'PO4',
                                    'Chla', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6',
                                    'a7'),
                        na.strings = "XXXXXXX")
  }
  algas
}

# Se invoca la base de "algas.txt"
algas <- load()


# Función 1; paso 2) Creamos la funciòn para la manipulación de los datos.
# Aquí hacemos las operaciones para la variable "mxPH".
str(algas)
mediana <- median(algas$mxPH, na.rm=T)
cuantil <- quantile(algas$mxPH, probs=c(.25,.75), na.rm=T)
RIQ <- cuantil[2]-cuantil[1]
res <- c(mediana,RIQ)
names(res) <- c("Mediana","RIQ")
res


# Función 1; paso 3) Generalizamos lo hecgho anteriormente para todas las variables
low.variability <- function(base) {
  formula <- function(variable) {
    if (class(variable) %in% c("numeric","integer")){
      mediana <- median(variable, na.rm=T)
      cuantil <- quantile(variable, probs=c(.25,.75), na.rm=T)
      RIQ <- cuantil[2]-cuantil[1]
      res <- list(mediana,RIQ,RIQ/mediana,class(variable))
      names(res) <- c("Mediana","RIQ","Mediana/RIQ","Clase.var")
      res
    }else{
      res <- list(0,0,0, class(variable))
      names(res) <- c("Mediana","RIQ","Mediana/RIQ","Clase.var")
      res
    }
  }
  a <- NULL
  for (i in 1:ncol(base)){
    a <- rbind(a,formula(base[,i]))
  }
  row.names(a) <- names(base)
  a
}


# Función 1; paso 4) Probamos la función en Algas
low.variability(algas) # Efectivamente funciona


# Función 2; paso 1) Se construye la función que indique aquellas variables que deban eliminarse
# por tener una alta correlación entre si.

correlation.filtering<-function(base){
  nums <- sapply(base, is.numeric)
  prueba<-base[,nums]
  prueba<-prueba[complete.cases(prueba),]
  corre<-NULL
  var1<-NULL
  var2<-NULL
  for(i in 1:(ncol(prueba)-1)){
    for(e in (i+1):ncol(prueba)){
      var1<-rbind(var1,names(prueba[i]))
      var2<-rbind(var2,names(prueba[e]))
      corre<-rbind(corre,cor(prueba[,i],prueba[,e]))
    }
  }
  a<-data.frame(var1=var1,var2=var2,correlacion=corre)
  a<-a[order(-abs(a$correlacion)),]
  a
}

# Función 2; paso 2) Se prueba la función.
correlation.filtering(algas)



# Función 3; paso 1) Se genera la función 
FCB.filtering<-function(base,variable){
  tabla<-correlation.filtering(base)
  tabla<-rbind(tabla[tabla$var1==variable,],tabla[tabla$var2==variable,])
  tabla[order(-abs(tabla$correlacion)),]
}


# Función 3; paso 2) Probamos
FCB.filtering(algas,"a6")



