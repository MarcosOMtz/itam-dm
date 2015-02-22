
load_data_german <- function(){
  if (!file.exists('german.rds'))
  {
    german.url <- paste('http://archive.ics.uci.edu/ml',
                        '/machine-learning-databases/statlog',
                        '/german/german.data',
                        sep='')
    
    german.data <- read.table(german.url, 
                              stringsAsFactors = FALSE, 
                              header = FALSE)
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
  
  a_ply( datos[,which(tipos=='numeric')] ,  .margins = 1, .fun = function(var){
    print(var)
    
    p <-   ggplot(datos, aes_string(x=var_cat_1, y=var , colour=var_cat_2) ) + 
      geom_boxplot() + 
      geom_violin() + 
      geom_jitter()
    if(!is.null(var_cat_3)){p <- p+ facet_wrap(datos,aes_string(~var_cat_3 )) }
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


normalizar  <- function(data){
  df  <- data.frame()
  for (n in 1:ncol(data)){
    if(class(data[,n])=="numeric"){
      data$n  <- (data[,n]-mean(data[,n],na.rm=T))/sd(data[,n],na.rm=T)
      
    }
  }
}



