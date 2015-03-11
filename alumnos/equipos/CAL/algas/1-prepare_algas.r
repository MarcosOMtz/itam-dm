# Asignamos un id a nuestra base, considerando un consecutivo

if (exists('ds$id') == FALSE){
  ds$id <- c(1:nrow(ds))
}

# Limpieza de metadatos utilizando la funci�n normalizarNombres

names(ds) <- normalizarNombres(names(ds))

# Ajuste de formatos utilizando la funci�n factorClass

ds <- factorClass(ds)

# Normalizar niveles utilizando la funci�n normalizarNombres

factors <- which(sapply(ds[names(ds)], is.factor))
for (f in factors) levels(ds[[f]]) <- normalizarNombres(levels(ds[[f]]))
