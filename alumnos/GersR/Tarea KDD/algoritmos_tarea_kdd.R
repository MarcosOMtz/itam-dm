

##Tarea

```{r}
# Cargamos el dataset
setwd("~/Dropbox/Maestría/itam-dm/alumnos/GersR/Tarea KDD")

ds.path <- "/Users/Gers/Dropbox/Maestría/itam-dm/data/KDD1998/cup98lrn.txt" # Puede ser un URL o una dirección en el directorio

ds.name <- "cup98lrn" # Nombre de nuestro conjunto de datos, e.g. algas, german

ds <- loadData(name=ds.name, full_path=ds.path, sep=",", head=TRUE)

ds <- tbl_df(ds) # Para obtener un print mejorado
```

## Convertir fecha en categorica: viejo, mediano, nuevo
```{r}
ds$fecha = as.POSIXlt(ds$odatedw*86400,origin="1970-01-01 00:00.00", tz="GMT")
ds$year = year(ds$fecha)
(cortes <- quantile(ds$fecha, c(0, 0.33,0.66,1)))
ds$antiguedad <- cut(ds$fecha, breaks = cortes, labels = c('viejo','mediano','nuevo'))
```

## Pasar el codigo postal a estado 
```{r}
zipcodes <- read.csv('zip_code_database.csv', header = TRUE, fill=TRUE)
zipcodes$zip <- as.character(zipcodes$zip)


arregla_zip <- function(zip){
  if(nchar(zip)<4){
    return(paste('00',zip,sep=''))
  }else{
    if(nchar(zip)==4){
      return(paste('0',zip,sep=''))
    }else{
      return(zip)
    }
  }
}

ds$zip <- apply(as.data.frame(ds$zip), 1, arregla_zip)
zipcodes <- zipcodes %>% select(zip,primary_city,state,latitude,longitude)
ds <- merge(ds,zipcodes,by='zip')

```

# Categoricas a numericas
```{r}
vars.categoricas

cat_to_numeric <- function(ds,vars.categoricas){
  for(var in vars.categoricas){
    tab <- prop.table(table(ds[,var]))
    noms <- names(tab)
    props <- as.numeric(tab)
    cambia <- function(x){
      ind = which(noms == x)
      return(props[ind])
    }
    ds[,paste(var,'.num',sep='')] <- apply(as.data.frame(ds[,var]),1,cambia)
  } 
  return(ds)
}
ds <- cat_to_numeric(ds,vars.categoricas)
```

# Quitar variables muy desbalanceadas
```{r}
muy_desbalanceado <- function(ds, vars.categoricas, max.prop = 0.9){
  vars.a.ignorar <- c()
  for(var in vars.categoricas){
    tab <- prop.table(table(ds[,var]))
    if(max(tab)>max.prop){
      vars.a.ignorar <- c(vars.a.ignorar, var)
    }
  }
  return(vars.a.ignorar)
}

vars.a.ignorar.2 <- muy_desbalanceado(ds,vars.categoricas,0.95)
vars.a.ignorar.2 
```