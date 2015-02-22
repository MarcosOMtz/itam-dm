#Descargar archivo si y solo si no existe el german.rds
source('../utils.r')

# Leo el archivo.
german.data <- loadData(name = 'german', 
                        full_path = '../../../data/german/german.data')
