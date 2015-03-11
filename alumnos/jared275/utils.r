
cargar_german<-function(){
  if (!file.exists("/home/jared/Proyectos/itam-dm/alumnos/jared275/german/german.rds")){
    german.url <- paste('http://archive.ics.uci.edu/ml','/machine-learning-databases/statlog',
                        '/german/german.data',sep='')
    saveRDS(object = german.data, file = "/home/jared/Proyectos/itam-dm/alumnos/jared275/german/german.rds")
  }
  readRDS("/home/jared/Proyectos/itam-dm/alumnos/jared275/german/german.rds")
}

chang_code<-function(){
  for (i in 1:nrow(german.data)){
    german.data<-replace(german.data,german.data==names(german.codes[i]),as.character(german.codes[i]))  
  }
  german.data
}

graf_expl<-function(data,var){
  library(ggplot2)
  if(is.numeric(data[,var])){
    cuantil<-quantile(data[,var],probs=c(.25,.5,.75),na.rm = T)
    prom<-mean(data[,var])
    ggplot(data,aes_string(x=var))+geom_density(alpha=.1,fill = "blue")+geom_histogram(alpha=.3,fill = "blue",aes(y=..density..))+geom_vline(xintercept=cuantil)+geom_vline(xintercept = prom, colour="green", linetype = "longdash")
    
  }
  else {
    a <- as.data.frame(table(data[,var]))
    ggplot(a,aes(x=reorder(Var1,Freq),y=Freq))+geom_bar(stat="identity")+theme(axis.text.x = element_text(angle = 35, hjust = 1))+scale_x_discrete(var)
  }
  
}

graf_expl2<-function(data,var1,var2){
  library(ggplot2)
  if(is.numeric(data[,var1]) & is.numeric(data[,var2])){
    ggplot(data,aes_string(x=var1,y=var2))+geom_point()+geom_smooth()
  }
  else if(is.numeric(data[,var1])) {
    ggplot(data,aes_string(x=var2,y=var1))+geom_boxplot()
  }
  else if(is.numeric(data[,var2])) {
    ggplot(data,aes_string(x=var1,y=var2))+geom_boxplot()
  } else {
    ggplot(data,aes_string(x=var1,fill=var2))+geom_bar() 
  }
}

imputarValorCentral <- function(data, var){
  if(is.numeric(data[,var])){
    data[is.na(var),var]<-median(data[,var],na.rm = T)
  } else {
    data[is.na(var),var]<-mode(data[,var])
  }
}


normalizarNombres<-function(data){
  b<-gsub("/",".",names(data))
  A<-LETTERS
  a<-paste(".",letters,separete="")
  for (i in 1:length(a)){
    b<-gsub(A[i],a[i],names(data))
  }
  b
}
