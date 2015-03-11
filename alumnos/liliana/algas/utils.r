
load_file <- function(){
  df <- read.table('/Users/Lili/Documents/itam/mineria_datos/adolfo/itam-dm/alumnos/liliana/algas/algas.txt',
                   na.strings="XXXXXXX")  
  saveRDS(df, 'algas/algas.rds')
}


graph_for_type <- function(df){
  #obtener los tipos de cada columna
  tipos <- lapply(df, function(x) class(x))
  
}

obtener_correlacion_entre_nas <- function(df){
  x <- as.data.frame(abs(is.na(df))) # df es un data.frame
  
  head(df)
  head(x)
  
  # Extrae las variables que tienen algunas celdas con NAs
  y <- x[which(sapply(x, sd) > 0)] 
  
  # Da la correación un valor alto positivo significa que desaparecen juntas.
  cor(y) 
}


###Feature selection
low.variability <- function(df){
  library(ggplot2)
  
  tipos <- sapply(df, class)
  numeric_cols <- which(tipos == 'numeric')
  
  #los ultimos 7 valores son los de prediccion
  variables <- numeric_cols[1:(length(numeric_cols)-7)]
  
  
  #sacar las medianas de cada columna numerica
  medians <- sapply(df[,variables], median, na.rm=TRUE)
    
  #sacar los quantiles de cada columna numerica
  quantiles <- as.data.frame(sapply(df[,variables], 
                                    quantile, probs=c(0.25, 0.75), na.rm=TRUE))
  
  #sacar el IQR de cada columna numerica
  iqrs <- as.numeric(quantiles[2,] - quantiles[1,])
  rownames(iqrs) <- NULL
  
  variability_df <- data.frame(medians=medians, iqrs=iqrs)
  
  #graficando mediana  vs iqrs
  ggplot(variability_df, aes(x=medians, y=iqrs, color=rownames(variability_df))) + geom_point() + ggtitle("Mediana vs IQRs")
  
  #se eliminan las que tengan una variabilidad menor a 0.20 
  a_eliminar <- which(iqrs < 1/5)
  features_selected <- NULL
  if(length(a_eliminar) > 0) {
    features_selected <- variables[-a_eliminar]
  }else {
    features_selected <- variables
  }
  
  features_selected
}



#eliminar variables que estan muy correlacionadas (sin tomar en cuenta la de salida) 
correlation.filtering <- function(df) {
  tipos <- sapply(df, class)
  numeric_cols <- which(tipos == 'numeric')
  
  #los ultimos 7 valores son los de prediccion
  variables <- numeric_cols[1:(length(numeric_cols)-7)]
  
  vars.cor <- cor(df[,variables], use='complete.obs')
  vars.cor[upper.tri(vars.cor, diag=TRUE)] <- NA
  
  vars.cor <- vars.cor                                  %>%
    abs()                                     %>%   
    data.frame()                              %>%
    mutate(var1=row.names(vars.cor))          %>%
    gather(var2, cor, -var1)                  %>%
    na.omit()
  
  
  vars.cor <- vars.cor[order(-abs(vars.cor$cor)), ]
  
  muy.cor <- filter(vars.cor, cor > 0.90) # Mostramos las que tengan más del 95% de correlación
  
  freatures_selected <- NULL
  if(dim(muy.cor)[1] > 0) {
    features_selected <- variables[-which(names(variables) == muy.cor$var1)]
  }else {
    features_selected <- variables
  }
  
  features_selected
}


#encontrar la correlacion de las variables con la de salida - V12
FCB.filtering() <- function(df) {
  tipos <- sapply(df, class)
  numeric_cols <- which(tipos == 'numeric')
  
  #los ultimos 7 valores son los de prediccion
  variables <- numeric_cols[1:(length(numeric_cols)-7)]
  output_var <- numeric_cols[9]
  
  s <- as.data.frame(cor(df[variables], df[output_var], use="complete.obs"))
  ordered <- with(s, order(-V12))
  x <- as.character(rownames(s))
  
  
  features_selected <- NULL
  while(length(variables) > 1) {
    revisadas <- variables[ordered[1]]
    features_selected <- append(features_selected, revisadas)
    variables <- variables[-ordered[1]]
    
    ss <- as.data.frame(cor(df[variables], df[revisadas], use="complete.obs"))
    if (length(which(ss > 0.90))) {
      variables <- variables[-which(ss > 0.90)]
    } 
    
    if (length(variables > 0)) {
      s <- as.data.frame(cor(df[variables], df[output_var], use="complete.obs"))
      ordered <- with(s, order(-V12))
      x <- as.character(rownames(s))
    }
  }
  
  features_selected
}


forward.filtering <- function(df){
  tipos <- sapply(df, class)
  numeric_cols <- which(tipos == 'numeric')
  
  #los ultimos 7 valores son los de prediccion
  variables <- numeric_cols[1:(length(numeric_cols)-7)]
  output_var <- numeric_cols[9]
  
  #primera variable
  output_lm <- lm(df[,output_var]~df[,variables[1]],na.action=na.omit)
  significativo <- summary(output_lm)$coefficients[,4]
  if (significativo < 0.005) {
    features_selected <- append(features_selected, variables[1])
  }

}