---
title: "EDA"
author: "Marcos, Carlos, Jared"
date: "25/11/2014"
output: html_document
---
Análisis exploratorio para la base de Algas

```{r, echo=FALSE,warning=FALSE, message=FALSE}
library(Hmisc)
library(corrplot)
source("/home/jared/Proyectos/itam-dm/alumnos/jared275/utils.r")
```

Cargamos nuestros datos y hacemos una pequeña exploración de los mismos:

```{r, warning=FALSE,message=FALSE}
algas <- read.table(file = "/home/jared/Proyectos/itam-dm/data/algas/algas.txt", 
                    header = FALSE,
                    dec = ".",
                    col.names = c('temporada', 'tamaño', 'velocidad', 'mxPH',
                                  'mnO2', 'Cl', 'NO3', 'NO4', 'oPO4', 'PO4',
                                  'Chla', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7'),
                    na.strings=c('XXXXXXX')
)
head(algas)
describe(algas)
```

Ahora con la función que creamos en utils.r, hacemos una exploración visual de los datos, esto para comprender mejor como se distribuyen.

```{r,warning=FALSE,message=FALSE}
for(i in 1:ncol(algas)){
  print (graf_expl(algas,names(algas[i])))
}
```

Ahora veamos las relaciones de dos en dos de las variables.

```{r,warning=FALSE,message=FALSE}
for(i in 1:(ncol(algas)-1)){
  for (e in (i+1):ncol(algas)){
    print (graf_expl2(algas,names(algas[i]),names(algas[e])))
  }
}
```

Aquí observamos las relaciones entre los datos faltantes, se observa que hay una clara relación entre la variable Chla y Cl.
Como también se puede ver una leve relación entre las variables Cl, NO3, NO4,oPO4,PO4 y Chla.

```{r,warning=FALSE,message=FALSE}
corr_na<-cor(is.na(algas))
corr_na[is.na(corr_na)]<-0
corrplot(corr_na)
```

Hacemos una función que sustituya los NA por la media, cuando es una variable numerica y por la moda cuando es una variable categorica.


```{r,warning=FALSE,message=FALSE}
sust_na<-function(col){
  if (is.numeric(col)){
    media<-mean(col, na.rm=T)
    col[is.na(col)]<-media
  } else {
    Mode <- function(x) {
      ux <- unique(x)
      ux[which.max(tabulate(match(x, ux)))]      
    }
    moda<-Mode(col)
    col[is.na(col)]<-moda
  }
  col
}
```

Ahora aplicamos esta función a todas las columas:
  
```{r,warning=FALSE,message=FALSE}
algas_2<-apply(algas,2,sust_na)
```

Comprobamos que no haya NAs,

```{r,warning=FALSE,message=FALSE}
corr_na_2<-cor(is.na(algas_2))
corr_na_2[is.na(corr_na_2)]<-0
corrplot(corr_na_2)
```

Como hubodos columnas en las que no le aplico la función, vamos a hacerlo con for loop.

```{r,warning=FALSE,message=FALSE}
algas_3<-algas
for (i in 1:ncol(algas)){
  algas_3[,i]<-sust_na(algas[,i])
}
```

Ahora vemos que sí removimos los NAs, con lo que concluimos nuestro análisis de NAs.

```{r,warning=FALSE,message=FALSE}
corr_na_3<-cor(is.na(algas_3))
corr_na_3[is.na(corr_na_3)]<-0
corrplot(corr_na_3)
```