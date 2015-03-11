# Función para verificar si en la carpeta german ya existe la base

load <- function(archivo){
  if (file.exists(archivo) == FALSE){
    # En caso de que no exista la base de datos la descargamos y guardamos
    german.url <- paste('http://archive.ics.uci.edu/ml',
                        '/machine-learning-databases/statlog',
                        '/german/german.data',
                        sep='')
    
    german.data <- read.table(german.url, 
                              stringsAsFactors = FALSE, 
                              header = FALSE)
    
    saveRDS(german.data, "german.rds")
    german.data
  }
  else{
    # Si la base ya existe en la carpeta la leemos
    german.data <- readRDS(archivo)
    german.data
  }
}

# Función para decodificar los elementos de las columnas de la base

german.decode <- function(columna, codigos){
  # Verificamos el tipo de dato de la columna
  tipo <- class(columna[,1])
  # Si el dato es caracter codificamos, de lo contrario la columna se queda igual
  if(tipo=='character'){
    columna <- lapply(columna, function(x) german.codes[x])
    columna <- lapply(columna, function(x) as.character(x))
    columna <- lapply(columna, function(x) as.factor(x))
    columna
  }
  else{
    columna
  }
}

# Función para modificar nombres de las columnas

rename <- function(nombres){
  nombres <- str_replace_all(nombres, " ", ".")
  nombres <- str_replace_all(nombres, "/", ".")
  nombres<- tolower(nombres)
  nombres
}


