# Algas

# Lectura de datos
algas <- read.table('../../data/algas/algas.txt',
                    header=FALSE,
                    dec=".",
                    na.strings = "XXXXXXX",
                    strip.white = TRUE,
                    col.names = c('temporada', 'tamaño', 'velocidad', 'mxPH',
                                  'mnO2', 'Cl', 'NO3', 'NO4', 'oPO4', 'PO4',
                                  'Chla', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7'))


missing.correlation <- data.frame(missing_corr(algas))

p <- ggplot(missing.correlation, aes(x=x,y=y))
p + geom_tile()
