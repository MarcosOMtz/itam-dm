library(plyr)
library(dplyr)

## dplyr mutate_each

german.decode  <-  function(data,list){
  # list = list(a = A, b = B, c=C,etc...)
  originales  <- names(data.frame(list))
  # deben ser caracteres y no factores
  nuevos  <- as.vector(unname(unlist(data.frame(list)[1,])))
  # múltiples columnas usando mutate_each
  data %>%
    mutate_each(funs(mapvalues(., from = originales, to = nuevos)))   
}

#agregar la conversión a factor si es caracter. 

german.data %>%
  mutate_each(funs(mapvalues(., from = originales, to = nuevos)))

colcaracter  <-  function(col){
  if(class(col)=character)    
}




