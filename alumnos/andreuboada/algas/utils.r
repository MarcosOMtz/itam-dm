library(plyr)
library(dplyr)
library(tidyr)
library(reshape2)
library(scales)
library(ggplot2)
library(arm)
library(RColorBrewer)
library(modeest)


# Lectura de datos de algas
load <- function(){
  if(!file.exists('algas.rds')){ #si el archivo no existe
    algas.data = read.table('algas.txt', stringsAsFactors = TRUE, 
                       header = FALSE, 
                       col.names = c('temporada', 'tamaño', 'velocidad', 'mxPH',
                                     'mnO2', 'Cl', 'NO3', 'NO4', 'oPO4', 'PO4',
                                     'Chla', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7'), na.strings='XXXXXXX')
    saveRDS(algas.data,'algas.rds')
  }else{ #si el archivo existe
    print('El archivo ya existe')
    algas.data = readRDS('algas.rds') # se lee el archivo
  }
  return(algas.data)
}
algas.data  <- load()

str(algas.data)
summary(algas.data)
sum(is.na(algas.data))


corr <- function(df){
  x <- as.data.frame(abs(is.na(df))) # df es un data.frame
  y <- x[which(sapply(x, sd) > 0)]
  return(cor(y))
}

mat_corr <- corr(algas.data)
df_corr <- data.frame(mat_corr)

library(arm)
corrplot(df_corr, color = TRUE) 

library(corrgram)
corrgram(df_corr, order = TRUE, lower.panel = panel.shade, 
         upper.panel = panel.pie, text.panel = panel.txt)

x <- as.data.frame(abs(is.na(algas.data))) # df es un data.frame
head(x)
# Extrae las variables que tienen algunas celdas con NAs
y <- x[which(sapply(x, sd) > 0)] 
#Grafico la correlación entre las variables con NA's
qplot(x=Var1, y=Var2, data=melt(cor(y, use="p")), fill=value, geom="tile") +
  scale_fill_gradient2(limits=c(-1, 1),low="orangered", high="slategray4") + 
  theme(axis.text.x  = element_text(angle=90)) + 
  ggtitle("Correlaciones entre los NA's") +
  xlab("") + ylab("")

#Obtengo un df con las variables numéricas de la base original
algas.dataNumeric<- algas.data[,sapply(algas.data, is.numeric)]
#Obtengo el número de columnas
nNumeric<-length(algas.dataNumeric)
#Obtengo los nombres de las columnas
columnasNumeric<-colnames(algas.dataNumeric)

#Mapa de correlaciones entre las variables numéricas
qplot(x=Var1, y=Var2, data=melt(cor(algas.dataNumeric, use="p")), fill=value, geom="tile") +
  scale_fill_gradient2(limits=c(-1, 1),low="orangered", high="slategray4") + 
  theme(axis.text.x  = element_text(angle=90)) + 
  ggtitle("Correlaciones entre las categorías") +
  xlab("") + ylab("")

#Veo qué tan normales son las variables
for(i in 1:nNumeric){
  show(ggplot(algas.dataNumeric, aes(sample=algas.dataNumeric[,i]) ) +
         stat_qq() +
         xlab("Cuantiles teóricos") + ylab(paste("Cuantiles de",columnasNumeric[i],sep=" ")) +
         ggtitle(paste("Q-Q plot para",columnasNumeric[i],sep=" ")))
}


#Scatter plots de datos Numéricos
for(i in 1:(nNumeric-1)){
  for(j in (i+1):nNumeric){
    xtitle<-columnasNumeric[i]
    ytitle<-columnasNumeric[j]
    title<-paste(xtitle,"vs",ytitle,sep=" ")
    show(ggplot(algas.dataNumeric,aes(x=algas.dataNumeric[,i],y=algas.dataNumeric[,j])) +
           geom_point() + scale_x_continuous(labels=comma) +
           scale_y_continuous(labels=comma) + 
           geom_smooth(method=lm) + 
           xlab(xtitle) + ylab(ytitle) + ggtitle(title))  
  }
  show(ggplot(algas.dataNumeric,aes(x=algas.dataNumeric[,i])) +
         geom_histogram(aes(y = ..density..)) + geom_density() + 
         xlab(xtitle) + ylab(ytitle) + ggtitle(xtitle))
}

#Bar charts para variables categóricas
algas.dataNonNumeric<-algas.data[,!sapply(algas.data, is.numeric)]
nNonNumeric<-length(algas.dataNonNumeric)
columnasNonNumeric<-colnames(algas.dataNonNumeric)
for(i in 1:nNonNumeric){
  counts <- as.data.frame(prop.table(table(algas.dataNonNumeric[,i])))
  show(ggplot(counts,aes(x=reorder(Var1,Freq),y=Freq)) + 
         geom_bar(stat='identity') + 
         coord_flip() +
         ylab("Proporción") + xlab("") +
         ggtitle(paste("Distribución de",columnasNonNumeric[i],sep=" ")))
}

#Cómo se muestran proporciones en vez de la cuenta?
#Cómo ordeno la gráfica?
for(i in 1:nNonNumeric){
  ncat_i = length(unique(algas.dataNonNumeric[,i]))
  for(j in 1:nNonNumeric){
    if(columnasNonNumeric[i]!=columnasNonNumeric[j]){
      ncat_j = length(unique(algas.dataNonNumeric[,j]))
      show(ggplot(algas.dataNonNumeric,aes(x=algas.dataNonNumeric[,i], fill=algas.dataNonNumeric[,j])) + 
             geom_bar(aes(y = (..count..)/sum(..count..))) + 
             coord_flip() +
             ylab("Proporción") + xlab("") +
             ggtitle(paste("Distribución de",columnasNonNumeric[i],"visto por",columnasNonNumeric[j],sep=" ")) +
             scale_fill_manual(values = brewer.pal(max(ncat_i,ncat_j),'RdPu'),name = columnasNonNumeric[j]))
    }
  }
}


#Hago boxplots
for(i in 1:nNumeric){
  for(j in 1:nNonNumeric){
    x<-toString(columnasNonNumeric[j])
    y<-toString(columnasNumeric[i])
    show(ggplot(algas.data,aes_string(x,y)) + 
           xlab(x) + ylab(y) + 
           geom_boxplot() +        
           ggtitle(paste(x,"vs",y,sep=" ")))
  }
}

indicesConNAs <- function(data, porcentaje=0.2) {
  n <- if (porcentaje < 1) {
    as.integer(porcentaje  * ncol(data))
  } else {
    stop("Debes de introducir el porcentaje de columnas con NAs.")
  }
  indices <- which( apply(data, 1, function(x) sum(is.na(x))) > n )
  if (!length(indices)) {
    warning("No hay observaciones con tantos NAs 
            (la respuesta de la función es vacía),
            no se recomienda indexar el data.frame con esto")
  }
  indices
}

indicesConNAs(algas.data, 0.2)

algas.data <- algas.data[-indicesConNAs(algas.data, 0.2),]

# algas.data$cat.with.NAs.fix <- ifelse(is.na(algas.data$cat.with.NAs),
#                                    "missing",
#                                    ifelse(algas.data$ccat.with.NAs == TRUE,    
#                                           # o el valor que sea
#                                           "level_1",
#                                           "level_2"))

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

imputarValorCentral <- function(data, colnames) {
  for(i in 1:length(colnames)){
    if(class(data[,colnames[i]])=='numeric'){
      ind = is.na(data[,colnames[i]])
      data[ind,colnames[i]] = rnorm(sum(ind), mean(data[,colnames[i]],na.rm = TRUE),sd(data[,colnames[i]], na.rm = TRUE))
    }else{
      ind = is.na(data[,colnames[i]])
      data[ind,colnames[i]] = Mode(data[,colnames[i]])
    }
  }
}

symnum(
  cor(algas.data[c('mxPH', 'mnO2', 'Cl', 'NO3', 'NO4', 'oPO4', 'PO4', 'Chla')], 
      use="complete.obs")
)

ggplot(data=algas) + 
  aes(x=oPO4, y=PO4) + 
  geom_point(shape=1) + # Usamos una bolita para los puntos
  geom_smooth(method=lm, se=FALSE)

na.ind <- is.na(algas.data$PO4)
modelo <- lm(PO4 ~ oPO4, data=algas.data)
summary(modelo)
pred <- predict.lm(modelo, algas.data[na.ind,])
algas.data[na.ind,'PO4'] <- pred
