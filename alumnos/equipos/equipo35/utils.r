source('two_plots.r')
source('utils_na.r')

normalizarNombres <- function(nombres_de_columnas) {
    # Quitamos trailing spaces y cambiamos espacios multiples por uno solo.
    nombres_de_columnas <- gsub("^ *|(?<= ) | *$", "", nombres_de_columnas, perl=T)
    # Cambiamos espacios por puntos
    nombres_de_columnas <- gsub(' ', '.', nombres_de_columnas)
    # Cambiamos casos como camelCase por camel.case
    nombres_de_columnas <- gsub("([a-z])([A-Z])", "\\1.\\L\\2", nombres_de_columnas, perl = TRUE)
    # Quitamos ñ's
    nombres_de_columnas <- gsub('ñ','n',nombres_de_columnas)
    # Quitamos mayusculas
    tolower(nombres_de_columnas)
}


#####################################################################################################
# UNIGRÁFICAS
graficas <- function(df){
  if (class(df) == "numeric"){
    p <- ggplot(data.frame(df), aes( x = df)) + geom_histogram(aes(fill = ..count..)) +
      geom_density()+
      labs(list(title = "Histograma",names(df)[1], x = names(df)[1], y = "frecuencia"))

  }
  if (class(df) == "factor") {
    p <- ggplot(data.frame(df), aes( factor(df))) + geom_bar(fill="purple", colour="magenta") +  labs(list(title = "Categorías", x = names(df)[1]))
  }
  print(p)
}



