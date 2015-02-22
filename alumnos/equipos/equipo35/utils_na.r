suma<- function(col)
{
  sum(is.na(col))
}

prom<- function(col)
{
  100*mean(is.na(col))
}

graf_corr<- function(df){
  x <- as.data.frame(abs(is.na(df))) # df es un data.frame
  y <- x[which(sapply(x, sd) > 0)]
  library(corrplot)
  M <- cor(y)
  corrplot(M, method = "circle")
}

indicesConNAs <- function(data, porcentaje) {
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

obs_nas <- function(data, numero) {
apply(data, 1, function(x) sum(is.na(x)))
data[apply(data, 1, function(x) sum(is.na(x))) > numero,]
}


elimina <- function(data, numero) {
data <- data[-indicesConNAs(data, numero),]
}


imputarValorCentral <- function(columna){
  if(class(columna)=="factor"){
    ua <- unique(a)
    relleno <- ua[which.max(tabulate(match(a, ua)))]
  }
  if(class(columna)=="numeric"){
    relleno <-mean(columna, na.rm = TRUE)
  }
  columna[is.na(columna)] <- relleno
  return(columna)
}

imputaRegresion <- function(interes,predictora,intercepto,slope){
    interes[is.na(interes)] <- intercepto+predictora[is.na(interes)]*slope
  return(interes)
}