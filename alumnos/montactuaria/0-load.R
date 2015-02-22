load  <-  function()
{
    if (file.exists('algas.txt')){
        algas  <-  read.table("algas.txt",header = FALSE,
                              dec = ".",
                              col.names = c('temporada', 'tamaÃ±o', 'velocidad', 'mxPH',
                                            'mnO2', 'Cl', 'NO3', 'NO4', 'oPO4', 'PO4',
                                            'Chla', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 
                                            'a7'), na.strings = "XXXXXXX")
    }
    else{
        algas <- read.table(file = "~/itam-dm/data/algas/algas.txt", 
                            header = FALSE,
                            dec = ".",
                            col.names = c('temporada', 'tamaÃ±o', 'velocidad', 'mxPH',
                                          'mnO2', 'Cl', 'NO3', 'NO4', 'oPO4', 'PO4',
                                          'Chla', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7'),
                            na.strings=c('XXXXXXX'))
    }
    algas
}




library(stringr)

loadData <- function(name, full_path, ...) {
  
  if (exists(name))
    stop("Error: No se indica el nombre del data source (ds), el argumento 'name' está vacío.")
  
  if (exists(full_path))
    stop("Error: No se indica la ruta para el archivo que contiene el data source, el argumento 'full_path' está vacío")
  
  ds <- NULL
  
  name <- paste(name, ".rds", sep="")
  
  rds_path <- paste("../rds","/", name, sep="")
  
  if(file.exists(rds_path)) {
    cat("Buscando el RDS en ", rds_path, "\n")
    cat(system.time(ds <- readRDS(file = rds_path)), "\n")
  } else {
    cat("Buscando el archivo en ", full_path, "\n")
    cat(system.time(ds <- read.table(full_path, ...)), "\n")
    cat("Guardando el RDS en ", rds_path, "\n")
    cat(system.time(saveRDS(object = ds, file = rds_path)), "\n")
  }
  
  ds
}