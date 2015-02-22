library(Hmisc)
library(dplyr)
library(tidyr)
library(ggplot2)
library(lubridate)
library(stringr)
rm(ls=list())

source(file = "../utils.r", chdir = TRUE)

ds.path <- "../../../data/KDD1998/cup98lrn.txt" # Puede ser un URL o una dirección en el directorio

ds.name <- "cup98" # Nombre de nuestro conjunto de datos, e.g. algas, german

ds <- loadData(name=ds.name, full_path=ds.path, sep=",", head=TRUE)




