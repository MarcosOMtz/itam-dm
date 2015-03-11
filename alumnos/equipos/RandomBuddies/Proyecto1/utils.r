library(plyr)
library(dplyr)
library(tidyr)
library(reshape2)
library(scales)
library(ggplot2)
library(arm)
library(RColorBrewer)
library(rattle)
library(stringr)

load<-function(base){
  if (!file.exists("algas.rds") && base=="algas"){
    datos <- read.table("algas.txt", 
                        stringsAsFactors = FALSE, 
                        header = FALSE,
                        col.names=c('temporada', 'tamano', 'velocidad', 'mxPH',
                                    'mnO2', 'Cl', 'NO3', 'NO4', 'oPO4', 'PO4',
                                    'Chla', 'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7'),
                        na.strings="XXXXXXX")
    saveRDS(datos,"algas.rds")
    datos
  }
  else{ if (base=="algas"){
    datos<-readRDS("algas.rds")
  }
  else{
    if(!file.exists('german.rds')){ #si el archivo no existe
      german.url <- paste('http://archive.ics.uci.edu/ml',
                          '/machine-learning-databases/statlog',
                          '/german/german.data',
                          sep='') #url de los datos
      # leer los datos de la red
      german.data <- read.table(german.url, 
                                stringsAsFactors = TRUE, 
                                header = FALSE,
                                col.names=c('Status of existing checking account', 
                                            'Duration in month',
                                            'Credit history',
                                            'Purpose',
                                            'Credit amount',
                                            'Savings account/bonds',
                                            'Present employment since',
                                            'Installment rate in percentage of disposable income',
                                            'Personal status and sex',
                                            'Other debtors / guarantors',
                                            'Present residence since',
                                            'Property',
                                            'Age in years',
                                            'Other installment plans',
                                            'Housing',
                                            'Number of existing credits at this bank',
                                            'Job',
                                            'Number of people being liable to provide maintenance for',
                                            'Telephone',
                                            'foreign worker',
                                            'Good.Loan')
      ) # lectura de datos
      saveRDS(german.data,'german.rds')
      return(german.data)
    }else{ #si el archivo existe
      print('El archivo ya existe')
      german.data = readRDS('german.rds') # se lee el archivo
      return(german.data)
    }
    
  }
  }
}

##############################################################################


normalizarNombres<-function(data.colnames){
  data.colnames <- data.colnames%>%str_replace_all(pattern=" ",replace=".")
  data.colnames <- data.colnames%>%str_replace_all(pattern="/.",replace="")
  data.colnames<-gsub("([a-z])([A-Z])", "\\1.\\L\\2", data.colnames, perl = TRUE)
}

graficosAE<-function(datos){
  
  ###################################
  #Gr??ficos para variables num??ricas#
  ##################################
  print(head(datos))
  #Obtengo un df con las variables num??ricas de la base original
  datosNumeric = datos[,sapply(datos, is.numeric)]
  print(datosNumeric)
  #Obtengo el n??mero de columnas
  nNumeric = length(datosNumeric)
  #Obtengo los nombres de las columnas
  columnasNumeric<-colnames(datosNumeric)
  
  #Mapa de correlaciones entre las variables num??ricas
  print(qplot(x=Var1, y=Var2, data=melt(cor(datosNumeric, use="p")), fill=value, geom="tile") +
          scale_fill_gradient2(limits=c(-1, 1),low="orangered", high="slategray4") + 
          theme(axis.text.x  = element_text(angle=90)) + 
          ggtitle("Correlaciones entre las num??ricas") +
          xlab("") + ylab(""))
  
  #Veo qu?? tan normales son las variables
  print(nNumeric)
  for(i in 1:nNumeric){
    localenv <- environment()
    print(ggplot(datosNumeric, aes(sample=datosNumeric[,i]), environment = localenv) +
            stat_qq() +
            xlab("Cuantiles te??ricos") + ylab(paste("Cuantiles de",columnasNumeric[i],sep=" ")) +
            ggtitle(paste("Q-Q plot para",columnasNumeric[i],sep=" ")))
  }
  
  #Scatter plots de datos Num??ricos
  for(i in 1:(nNumeric-1)){
    for(j in (i+1):nNumeric){
      xtitle<-columnasNumeric[i]
      ytitle<-columnasNumeric[j]
      title<-paste(xtitle,"vs",ytitle,sep=" ")
      title2<-(paste("Histograma de x ", xtitle,sep=" "))
      localenv <- environment()
      print(ggplot(datosNumeric,aes(x=datosNumeric[,i],y=datosNumeric[,j]), environment = localenv) +
              geom_point() + scale_x_continuous(labels=comma) +
              scale_y_continuous(labels=comma) + 
              geom_smooth(method=lm) + 
              xlab(xtitle) + ylab(ytitle) + ggtitle(title))           
    }
    localenv <- environment()
    print(ggplot(datosNumeric,aes(x=datosNumeric[,i]), environment = localenv)+geom_histogram(aes(y=..density..))+geom_density()+xlab(xtitle)+ggtitle(title2))
  }
  
  ######################################
  #Gr??ficos para variables categ??ricas#
  ####################################
  
  #Obtengo un df con las variables num??ricas de la base original
  datosNonNumeric = datos[,!sapply(datos, is.numeric)]
  #print(datosNumeric)
  #Obtengo el n??mero de columnas
  nNonNumeric = length(datosNonNumeric)
  
  #Obtengo los nombres de las columnas
  columnasNonNumeric<-colnames(datosNonNumeric)
  
  #C??mo ordeno la gr??fica?
  for(i in 1:nNonNumeric){
    ncat_i = length(unique(datosNonNumeric[,i]))
    for(j in 1:nNonNumeric){
      if(columnasNonNumeric[i]!=columnasNonNumeric[j]){
        ncat_j = length(unique(datosNonNumeric[,j]))
        localenv <- environment()
        print(ggplot(datosNonNumeric,aes(x=datosNonNumeric[,i], fill=datosNonNumeric[,j]), environment = localenv) + 
                geom_bar(aes(y = (..count..)/sum(..count..))) + 
                coord_flip() +
                ylab("Proporci??n") + xlab("") +
                ggtitle(paste("Distribuci??n de",columnasNonNumeric[i],"visto por",columnasNonNumeric[j],sep=" ")) +
                scale_fill_manual(values = brewer.pal(max(ncat_i,ncat_j),'Paired'),name = columnasNonNumeric[j]))
      }
    }
  }
  
  #Bar charts para variables categ??ricas
  datosNonNumeric<-datos[,!sapply(datos, is.numeric)]
  nNonNumeric<-length(datosNonNumeric)
  columnasNonNumeric<-colnames(datosNonNumeric)
  for(i in 1:nNonNumeric){
    counts <- as.data.frame(prop.table(table(datosNonNumeric[,i])))
    localenv <- environment()
    print(ggplot(counts,aes(x=reorder(Var1,Freq),y=Freq), environment = localenv) + 
            geom_bar(stat='identity') + 
            coord_flip() +
            ylab("Proporci??n") + xlab("") +
            ggtitle(paste("Distribuci??n de",columnasNonNumeric[i],sep=" ")))
  }
  
  ######################
  #Gr??ficos combinados#
  ####################
  
  #Hago boxplots
  for(i in 1:nNumeric){
    for(j in 1:nNonNumeric){
      x<-toString(columnasNonNumeric[j])
      y<-toString(columnasNumeric[i])
      localenv <- environment()
      print(ggplot(datos,aes_string(x,y), environment = localenv) + 
              xlab(x) + ylab(y) + 
              geom_boxplot() +        
              ggtitle(paste(x,"vs",y,sep=" ")))
    }
  }
  
  ###########################################################
  #Gr??fica de correlaciones para las variables con missings#
  #########################################################
  
  x <- as.data.frame(abs(is.na(datos))) # df es un data.frame
  # Extrae las variables que tienen algunas celdas con NAs
  y <- x[which(sapply(x, sd) > 0)] 
  #Grafico la correlaci??n entre las variables con NA's
  ifelse(sum(x)==0,"No hay NA's",print(qplot(x=Var1, y=Var2, data=melt(cor(y, use="p")), fill=value, geom="tile") +
          scale_fill_gradient2(limits=c(-1, 1),low="orangered", high="slategray4") + 
          theme(axis.text.x  = element_text(angle=90)) + 
          ggtitle("Correlaciones entre los NA's") +
          xlab("") + ylab("")))
  
}

#Indices con NA's

indicesConNAs <- function(datos, porcentaje=0.2) {
  n <- if (porcentaje < 1) {
    as.integer(porcentaje  * ncol(datos))
  } else {
    stop("Debes de introducir el porcentaje de columnas con NAs.")
  }
  indices <- which( apply(datos, 1, function(x) sum(is.na(x))) > n )
  if (!length(indices)) {
    warning("No hay observaciones con tantos NAs 
            (la respuesta de la funci??n es vac??a),
            no se recomienda indexar el data.frame con esto")
  }
  indices
}
