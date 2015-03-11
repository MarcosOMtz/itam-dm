#load de los datos de algas.
rm(list=ls())
gc()
source('../utils.r')
ls()
algas <- load_data_algas()
head(algas)
