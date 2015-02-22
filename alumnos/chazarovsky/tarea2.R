#EDWIN CHAZARO ARGUETA - TAREA 2

#Mis funciones operan sobre variables numericas asi que primero identifico cuales son numericas
#probare con el dataset de KDD1998

ds <- read.table("/Users/Chazaro1/itam-dm/data/KDD1998/cup98lrn.txt", sep=",", head=TRUE)
ids.numericas <- which(sapply(ds, is.numeric))
vars.numericas <- names(ds)[ids.numericas]

###Filtrado basado en las propiedades de la distribución
#Esta funcion calcula el rango intercuantilico, la mediana y estandariza el IQR dividiendolo por la mediana
low.variability <- function(data){
  cuartiles <- quantile(data, na.rm = TRUE)
  RIQ <- as.numeric(cuartiles[4]-cuartiles[2])
  mediana <- as.numeric(cuartiles[3]) 
  vari <- round(RIQ/mediana,digits=1)
  vari
}

low.variability(ds$VC3) #La pruebo con una variable
todos <-sapply(ds[ids.numericas], low.variability)#la pruebo con todas
vars.numericas %>% data.frame() %>% mutate (variabilidad=todos) %>% arrange(variabilidad) %>% na.omit()#convierno a mi lista de variables numericas en un data frame, luego le agrego una columna con los resultados de mi funcion y llamo a esa columna "variabilidad" finalmente ordeno los resultados de menor a mayor variabilidad y elimino los NaN

###Correlation Filtering
#Esta funcion calcula la correlacion
correlation.filtering <- function(data){
vars.cor <- cor(data) #calculo la correlacion de todas las combinaciones
vars.cor[lower.tri(vars.cor, diag=TRUE)] <- NA #lleno con NAs el triangulo inferior incluida la diagonal que tiene puros 1s para no tener duplicados
resultado <- vars.cor%>%abs()%>% round(digits=3)%>%data.frame()%>%mutate(var1=row.names(vars.cor))%>%gather(var2, correlacion, -var1)%>%na.omit()%>% arrange(desc(correlacion)) #saco el valor absoluto de la correlacion, lo redondeo a 3 digitos, convierto el resultado en un data frame, agrego una columna con el nombre de las variables, consildo la informacion, elimino los nas y ordeno por correlacion.
resultado
}

# antes de aplicar la funcion se tendria que remover la variable de interes con:
# vars.numericas <- vars.numericas[-interes]
correlation.filtering(ds[vars.numericas]) #pruebo la funcion



## Fast correlation-based filtering

FCB.filtering <- function(data,interes){ 
corint <- cor(data[interes],data)%>%abs()%>% round(digits=3)%>% as.numeric()#la pruebo con todas
resultado <- vars.numericas %>% data.frame() %>% mutate (correlacion=corint) %>% arrange(desc(correlacion)) %>% na.omit()
resultado
}
                     
FCB.filtering(ds[vars.numericas], "HV1") #pruebo la funcion
                                                                            
