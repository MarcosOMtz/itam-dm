# Asignamos un id a nuestra base, considerando un consecutivo

ds$id <- c(1:nrow(ds))
ds.original$id <- c(1:nrow(ds))

# Se define la variable Good.Loan como categorica

ds$Good.Loan <- as.factor(
  ifelse(
    ds$Good.Loan == 1, 
    'GoodLoan', 
    'BadLoan'
  )
)

ds.original$Good.Loan <- as.factor(
  ifelse(
    ds.original$Good.Loan == 1, 
    'GoodLoan', 
    'BadLoan'
  )
)

# Limpieza de metadatos utilizando la función normalizarNombres

names(ds) <- normalizarNombres(names(ds))
names(ds.original) <- normalizarNombres(names(ds.original))

# Ajuste de formatos utilizando la función factorClass

ds <- factorClass(ds)
ds.original <- factorClass(ds.original)

# Normalizar niveles utilizando la función normalizarNombres

factors <- which(sapply(ds[names(ds)], is.factor))
for (f in factors) levels(ds[[f]]) <- normalizarNombres(levels(ds[[f]]))

