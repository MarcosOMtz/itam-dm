# Cargamos la base de datos usando función load

ds <- load(ds.name, ds.path, ds.url)

# Definimos el vector con los nombres de las variables

ds.colnames <- c('temporada', 
                 'tamaño',
                 'velocidad',
                 'mxPH',
                 'mnO2',
                 'C1',
                 'NO3',
                 'NO4',
                 'oPO4',
                 'PO4',
                 'Chla',
                 'a1',
                 'a2',
                 'a3',
                 'a4',
                 'a5',
                 'a6',
                 'a7')

# Asignamos nombres a las variables de la base 

colnames(ds) <- ds.colnames


