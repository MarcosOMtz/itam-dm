# Función que descarga datos y carga 'german.rds' sii no existe este archivo.
load <- function(){
  german.url <- paste('http://archive.ics.uci.edu/ml',
                      '/machine-learning-databases/statlog',
                      '/german/german.data',
                      sep='')
  if (!file.exists('german.rds')){
    german.data <- read.table(german.url, 
                              stringsAsFactors = FALSE, 
                              header = FALSE)
    saveRDS(german.data, file = 'german.rds')
  }
  readRDS('german.rds')
}

