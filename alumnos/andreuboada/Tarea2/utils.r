# utils.r feature selection
library(dplyr)
library(tidyr)
library(reshape2)
library(ggplot2)

# Regresa los nombres de columnas de variables
# con poca variabilidad
low.variability <- function(datos, threshold = 0.2){
  
  # Sacamos nombres de columnas numericas
  datosNumeric <- scale(datos[,sapply(datos, is.numeric)], center = TRUE,scale = TRUE)
  columnasNumeric <- names(datosNumeric)
  nNumeric = length(datosNumeric)

  # 1. Obtener para cada variable su mediana, 1er, 3er cuartil
  cuantiles <- data.frame(t(apply(datosNumeric,2,quantile,probs = c(.25,.5,.75),na.rm = TRUE)))
  # 2. Obtener IQR
  cuantiles$iqr = cuantiles$X75. -  cuantiles$X25.
  # 3. Realice un scatter-plot entre ambas variables, esta 
  # gráfica nos da una visión de la distribución de las variables.
  ggplot(cuantiles, aes(x=X50., y=iqr)) + geom_point()
  # 4. Eliminemos las variables que tengan "baja variabilidad"
  return(row.names(cuantiles[cuantiles[,4]<threshold,]))
}


correlation.filtering <- function(datos, threshold = 0.95){
  vars.cor <- cor(datos[which(sapply(datos, is.numeric))], use="pairwise.complete.obs")
  vars.cor <- vars.cor %>%
    abs() %>%   
    data.frame() %>%
    mutate(var1=row.names(vars.cor)) %>%
    gather(var2, cor, -var1) %>%
    na.omit()
  vars.cor <- vars.cor[order(-abs(vars.cor$cor)), ] %>% filter(cor < 1)
  return(unique(as.character(filter(vars.cor, cor > threshold)$var2)))
}

correlation.filtering<-function(datos,threshold=.95){
  datosNumeric <- datos[,sapply(datos, is.numeric)]
  correlaciones<-melt(cor(datosNumeric, use="p"))
  correlaciones<-correlaciones[correlaciones[,1]!=correlaciones[,2],]
  muy.cor<-correlaciones[abs(correlaciones[,3])>threshold,]
  return(unique(as.character(muy.cor$Var2)))
}

FCB.filtering <- function(datos, yname, delta = 0.2){
  termina = FALSE
  df = datos[which(sapply(datos, is.numeric))]
  vars <- colnames(df)
  vars.quitan <- c()
  ls <- c()
  y = datos[,yname]
  corr <- abs(apply(df, 2, cor, y, use = "p"))
  corr <- corr[names(corr) != yname]
  corr <- corr[order(corr,decreasing = TRUE)]
  var <- as.character(names(corr[1]))
  ls <- c(ls,var)
  yn <- datos[,var]
  corr2 <- abs(apply(df, 2, cor, yn, use = "p"))
  corr2 <- corr[names(corr) != var & names(corr) != yname]
  while(any(corr2 > delta) & !termina){
    vars.quitan = c(vars.quitan,names(corr2[corr2>delta]))
    df = df[,!(colnames(df) %in% vars.quitan | colnames(df) %in% ls)]
    if(length(colnames(df))>0){
      corr <- abs(apply(df, 2, cor, y, use = "p"))
      corr <- corr[names(corr) != yname]
      corr <- corr[order(corr,decreasing = TRUE)]
      var <- as.character(names(corr[1]))
      ls <- c(ls,var)
      yn <- datos[,var]
      corr2 <- abs(apply(df, 2, cor, yn, use = "p"))
      corr2 <- corr[names(corr) != var & names(corr) != yname]
    }else{
      termina = TRUE
    }
  }
  return(vars.quitan)
}


epsilon.categorico<-function(datos,C="tamano",threshold=2){
  datos.categoricos<- datos[which(!sapply(datos, is.numeric))]
  cols<-colnames(datos.categoricos)[names(datos.categoricos)!=C]
  ls<-c()
  n<-length(cols)
  for(i in 1:n){
    group1<-datos.categoricos %>% group_by(feature=datos.categoricos[,cols[i]]) %>% summarise(proba.Temporada=n()/dim(datos)[1])
    group2<-datos.categoricos %>% group_by(Clase=datos.categoricos[,C]) %>% summarise(PC=n()/dim(datos)[1])
    tablaEpsilon<- datos.categoricos %>% 
      group_by(Clase,feature=datos.categoricos[,cols[i]]) %>%
      summarise(Nx=n(),prob=n()/dim(datos)[1]) %>% 
      merge(group1,by="feature") %>%
      merge(group2,by="Clase") %>%
      mutate(epsilon=Nx*(prob/proba.Temporada-PC)/sqrt(Nx*PC*(1-PC)))
    epsilon<-max(tablaEpsilon$epsilon)
    if(epsilon<threshold){
      ls<-c(ls,cols[i])
    }
  }
  return(ls)
}



