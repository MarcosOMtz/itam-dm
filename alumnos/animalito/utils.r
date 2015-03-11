explore <- function(df){
    df
}

missing_corr <- function(df){
    # Valores faltantes
    x <- as.data.frame(abs(is.na(df)))
    # Extrae las variables que tienen algunas celdas con NAs
    y <- x[which(sapply(x, sd) > 0)]
    # Da la correación un valor alto positivo significa que desaparecen juntas.
    cor(y)
}
