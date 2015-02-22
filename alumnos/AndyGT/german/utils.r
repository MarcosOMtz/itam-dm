
#Crea una función load en utils.r en tu carpeta, que descargue, si y sólo si no existe un archivo german.rds. Si no existe, descarga y guarda el archivo.

?saveRDS

load_data <- function(){
  german.url <- paste('http://archive.ics.uci.edu/ml',
                      '/machine-learning-databases/statlog',
                      '/german/german.data',
                      sep='')
  
  if (!file.exists('german.rds')) {
    file = read.table(german.url, stringsAsFactors = FALSE, header = FALSE)
    saveRDS(file, 'german.rds')
  }
  
  readRDS('german.rds')
}


#Utiliza lapply para decodificar todas las columnas de german.data

# para decodificar 
german.decode <- function(row, german.codes){
  class <- class(row[,1])
  if(class=='factor'){
    row <- lapply(row, function(x) german.codes[x])
    row <- lapply(row, function(x) as.character(x))
    row <- lapply(row, function(x) as.factor(x))
    row
  }
  else{
    row
  }
}

# aplicar la funcion a cada columna
for (i in 1:21){
  german.data[i] <- german.decode(german.data[i], german.codes)
}







