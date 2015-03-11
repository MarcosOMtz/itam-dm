# Funci??n que descarga datos y carga 'german.rds' sii no existe este archivo.
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

#Leer los datos
algas <- read.table("~/data-mining-test/proyectos/itam/alumnos/andreslechuga/algas/algas.txt", quote="\"")
View(algas)

algas.colnames <- c('temporada', 
                     'tamano',
                     'velocidad',
                     'mxPH',
                     'mno2',
                     'Cl',
                     'NO3',
                     'NO4',
                     'oPO4',
                     'PO4',
                     'ChLa',
)



