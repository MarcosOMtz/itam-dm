
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
  
  ds
}



load_data_german <- function(){
  if (!file.exists('german.rds'))
  {
    german.url <- paste('http://archive.ics.uci.edu/ml',
                        '/machine-learning-databases/statlog',
                        '/german/german.data',
                        sep='')
    
    german.data <- read.table(german.url, 
                              stringsAsFactors = FAlistaE, 
                              header = FAlistaE)
    saveRDS(object = german.data, file = 'german.rds')
    german.data
  }
  else
  {
    german.data <- readRDS('german.rds')
    german.data
  }
}

load_data_algas<- function(){
  if (!file.exists('algas.rds'))
  {
    algas <- read.table('../../data/algas/algas.txt',
                        # col.names = c('temporada', 'tamaño','velocidad','mxPH',
                        #              'mn02','Cl','N03','N04','oP04','P04','Chla'),
                        stringsAsFactors = T,
                        na.strings = 'XXXXXXX' 
    )
    
    saveRDS(object = algas, file = 'algas.rds')
  }
  else
  {
    algas <- readRDS('algas.rds')
  }
  algas
}





library(plyr)

eda_1 <- function(datos,var_cat_1,var_cat_2=NULL, var_cat_3=NULL){
  tipos <- sapply(names(datos),function(i){class(datos[,i])})
  tipos_num <- names(which(tipos=='numeric'))
  
#   var_cat_1='V1'
#   var_cat_2='V2'
#   var_cat_3='V3'
  a_ply(tipos_num  ,  .margins = 1, .fun = function(var){
    print(var)
    
    p <-   ggplot(datos, aes_string(x=var_cat_1, y=var , colour=var_cat_2) ) + 
      geom_boxplot() + 
      geom_violin() + 
      geom_jitter()
    if(!is.null(var_cat_3)){p <- p+ facet_wrap(var_cat_3 ) }
    print(p)
    
  }) 
}




matrix_cor_nas <- function(df){
  x <- as.data.frame(abs(is.na(df))) 
  y <- x[which(sapply(x, sd) > 0)] 
  # Da la correación un valor alto positivo significa que desaparecen juntas.
  cor(y) 
}




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



# Función:
normalizarNombres <- function(df.colnames) {
  
  require(stringr)
  
  
  df.colnames <- str_replace_all(df.colnames,"([[:punct:]])|\\s+",".")
  df.colnames <- gsub("([a-z])([A-Z])", "\\1.\\L\\2", df.colnames, 
                      perl = TRUE)
  df.colnames  <- sub("^(.[a-z])", "\\L\\1", df.colnames, perl = TRUE)
  df.colnames  <- tolower(df.colnames)
}


pruebaChiCuadrada <- function(var1, var2) {
  tabla <- table(var1, var2)
  
  plot(tabla, main=var1, las=1)
  
  print(var1)
  
  print(chisq.test(tabla))
}


## Predicciones


predecirVariableCategorica <- function(outCol, varCol, appCol, pos) {
  pPos <- sum(outCol == pos) / length(outCol)
  naTab <- table(as.factor(outCol[is.na(varCol)]))
  pPosWna <- (naTab/sum(naTab))[pos]
  vTab <- table(as.factor(outCol), varCol)
  pPosWv <- (vTab[pos,]+1.0e-3*pPos)/(colistaums(vTab)+1.0e-3)
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



#### FEATURE SELECTION

#### low variability

low.variability  <- function(df){
  options("scipen"=100, "digits"=4) # indico quitar expr cientifica
  quantile  <- apply(df, 2, FUN = quantile) # visualizo los quantiles
  IQR  <- apply(df,2,FUN=IQR) # visualizdo el IQR
  var  <- (apply(df,2,FUN=IQR) /
             (apply(df,2,FUN=max)-apply(df,2,FUN=min)))*100 #IQR/rango
  tb  <- round(rbind(quantile,IQR,var),4)
  tb 
}



### Feature selecction 

correlation.filtering  <- function(df){
  require(corrgram)
  cor  <-  cor(df,use="complete.obs")
  print(corrgram(df, order=TRUE, lower.panel=panel.shade,
           upper.panel=panel.pie, text.panel=panel.txt,
           main="Feature Selection") )
  cor 
}

#### Fast correlation-based filtering 
FCB.filtering  <- function(df,y){
  # df dataframe
  # y la variable objetivo
  df  <- as.data.frame(cor(sub_num,use="complete.obs"))
  df2  <- as.data.frame(df[with(df,order(-y)),])
  df2  <- df2[df2==1]  <-  0
  muy_cor <- which.max(df2[2,] > .85)
  na  <- names(df2)[muy_cor]
  df2 <- df2[-muy_cor]
  df2 
}

epsilon <- function( datos , y , tol=1){
  
  require(plyr)
  require(dplyr)
  datos.c <- datos[ which( !sapply( datos, is.numeric))]
  vars.cat <- names( datos.c )[names( datos.c)!=y]
  lista <- c()
  n <- length(vars.cat)
  
  for(i in 1:n){
    
    group1 <- datos.c %>% 
      group_by(feature=datos.c[,vars.cat[i]]) %>% 
      summarise(proba.Temporada=n()/dim(datos)[1])
    
    group2 <- datos.c %>% 
      group_by( Clase = datos.c[,y]) %>%
      dplyr::summarise(PC=n()/dim(datos)[1])
    
    tablaEpsilon<- datos.c %>% 
      group_by(Clase=datos.c[,y] ,
               feature=datos.c[, vars.cat[i] ] ) %>%
      dplyr::summarise( Nx=n(),
                        prob=n()/nrow(datos) ) %>% 
      merge( group1, by="feature" ) %>%
      merge( group2, by="Clase" ) %>%
      dplyr::mutate( epsilon = Nx*( prob/ proba.Temporada - PC)/sqrt(Nx * PC* (1-PC) ) )
    
    eps <- max(tablaEpsilon$epsilon)
    
    if(eps<tol){
      lista<- c( lista, vars.cat[i] )
    }
  }
  
  vars.num<- colnames( datos[ which( sapply( datos, is.numeric))])
  datos.num <-datos[, c( y, vars.num)]
  
  datos.num[2: ncol(datos.num) ] <- scale(datos.num[ 2:ncol(datos.num)],
                                         center=TRUE,scale=TRUE)
  
  n <- length(vars.num)
  
  clases <- unique(datos.num[,y])
  m <- length(clases)
  
  for(i in 1:n){  
    for(j in 1:m){
      df1 <- datos.num[ datos.num[,y] == as.character( clases[j] ) , ]
      N1<-nrow(df1)
      mean1<-mean(df1[,vars.num[i]],na.rm=TRUE)
      var1<-var(df1[,vars.num[i]],na.rm=TRUE)
      
      df2 <- datos.num[ datos.num[,y] != as.character( clases[j] ), ]
      N2 <- nrow(df2)
      
      mean2 <- mean(df2[,vars.num[i]],na.rm=TRUE)
      var2 <- var(df2[,vars.num[i]],na.rm=TRUE)
      eps.num <- -1e6
      x <- ifelse(is.nan((mean1-mean2) / sqrt( var1/N1 - var2/N2 ))
                  , eps.num,
                  (mean1-mean2) / sqrt( var1/N1 - var2/N2 ))
      eps.num <- ifelse( eps.num <  x,
                         eps.num <- x,
                         eps.num )
    }
    if( eps.num < tol ){
      lista<-c( lista , vars.num[i])
    }
  }
  return(lista)
}