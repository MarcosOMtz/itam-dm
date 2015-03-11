setwd('/Users/Lili/Documents/itam/mineria_datos/adolfo/itam-dm/alumnos/liliana/german')

source("utils.R")

df <- load_file()
df <- german.decode(df)
df <- format_headers(df)
grafica(df)
