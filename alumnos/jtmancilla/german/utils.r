load  <-  function()
    {
    if (file.exists('german.rds')){
        german.data <- readRDS('german.rds')
        german.data
    }
    else{
        german.url <- paste('http:/archive.ics.uci.edu/ml',
                            '/machine-learning-databases/statlog',
                            '/german/german.data',
                            sep='')
        
        german.data <- read.table(german.url, 
                                  stringsAsFactors = FALSE, 
                                  header = FALSE)
        saveRDS(object = german.data, file = 'german.rds')
        german.data
    }   
}

library(plyr)
library(dplyr)

## dplyr mutate_each

german.decode  <-  function(data,list){
    # list = list(a = A, b = B, c=C,etc...)
    originales  <- names(data.frame(list))
    # deben ser caracteres y no factores
    nuevos  <- as.vector(unname(unlist(data.frame(list)[1,])))
    # múltiples columnas usando mutate_each
    data %>%
        mutate_each(funs(mapvalues(., from = originales, to = nuevos)))   
}



# Essential Tools for Data Science with R
#browseVignettes(package="dplyr")

#http://jimhester.github.io/plyrToDplyr/
    
# tidyr, dplyr, ggvis
    
    
    
    
eda1 <- function(df,n=1) {
    
    #gráfica por columna. df = dataframe, n=numero de columnas a visualizar.
    
    require(dplyr)
    require(scales)
    require(ggplot2)
    require(gridExtra)
    require(grid)
    require(ggthemes)
    
    # loop para saber si es un número o un vector con las columnas.
    
    if (length(n)==1){
        ncol  <-  sample(1:ncol(df),n,replace=F) #selecciono por 
        #muestreo las columnas a
        #graficar
    }
    
    else{
        ncol  <-  n
    }
    
    
    for (n in ncol){
        
        #si es categórica, visualizar su frecuencia relativa
        
        if(class(df[,n]) == "factor"){
            
            df2 <- as.data.frame(prop.table(table(df[,n])))
            ggp <- ggplot(df2, aes(x=reorder(Var1,-Freq), y=Freq)) +
                geom_bar(stat='identity', fill="darkred", color="black")+
                scale_y_continuous(labels=percent) + 
                theme_wsj()+
                ggtitle(paste(names(df)[n]))+
                xlab(names(df)[n])+
                geom_text(aes(label=paste((Freq)*100,"%")), vjust=-.25)
            plot(ggp)
            
        }
        # si es numerico visulizar por histograma
        else{
            ggp  <-  ggplot(df, aes_string(x=names(df)[n]))+
                geom_histogram(aes(y = ..density..),
                               fill="steelblue", color="white")+
                geom_density()+
                theme_economist()+
                ggtitle(paste(names(df)[n]))+
                scale_y_continuous(labels=percent)+
                annotation_custom(grobTree(textGrob
                                           (paste("mean = ",round(mean(df[,n],na.rm=T),2),
                                                  " ","sd =", 
                                                  round(sd(df[,n],na.rm=T),2)), 
                                            x=0.1,  y=0.97, hjust=0, gp=gpar(
                                                col="black", 
                                                fontsize=13, fontface="italic"))))
            
            ggp2  <- ggplot(df, aes_string(x=factor(0), y=names(df)[n]))  + 
                #ojo: la densidad utiliza método kernel
                #(no paramétrica), y lo que más importa es la forma.
                #geom_boxplot(fill="gray") + 
                geom_violin(alpha=0.5, color="gray")+
                geom_jitter(alpha=0.5, colour="darkred",                                                 
                            position = position_jitter(width = 0.1))+
                theme_solarized_2() + coord_flip()+ 
                ggtitle(paste(names(df)[n]))+
                annotation_custom(grobTree(textGrob(
                    paste("Q-25% = ",
                          as.vector(quantile(df[,n],na.rm=T)[2]),
                          ",  Q-50% = ",
                          as.vector(quantile(df[,n],na.rm=T)[3]),
                          ",  Q-75% =",as.vector
                          (quantile(df[,n],na.rm=T)[4])),x=0.1,  y=0.97, 
                    hjust=0, gp=gpar(col="black", fontsize=13, 
                                     fontface="italic"))))
            
            # +stat_qq()
            #geom_abline() + theme_bw()+
            #ggtitle("Normal Q-Q")
            grid.newpage()
            pushViewport(viewport(layout = grid.layout(2, 1)))
            print(ggp, vp = viewport(layout.pos.row = 2, layout.pos.col = 1))
            print(ggp2, vp = viewport(layout.pos.row = 1, layout.pos.col = 1))          
            #plot(ggp)
        }
        
    }
}




#Ejemplo para visualizar al dataframe= algas.data, y 4 columnas de manera aleatoria.

#eda1(algas.data,4)

#Ejemplo para visualizar al dataframe= algas.data, y 5 columnas indicadas (vector con el numero de las columnas).

#eda1(algas.data,c(3,9,5,11,16))

#gc()

#FUNCIÓN eda2, función de exploración para visualizar la relación de dos
#variables.  Le indicas el dataframe y la posición de la variable base que no 
#se moverá  y le indicas o no contra que columnas se compará. 
#Si no se especifica el vector con el numero de las columnas a comparar,
# la base se compara con todas las columnas.



eda2  <-  function(df,n,col=NULL){
    #df = datafrema, n= el numero de la columna con la covariable base
    # col = el vector con el número de las columnas en específico contra
    #la cual comparar
    
    require(dplyr)
    require(scales)
    require(ggplot2)
    require(gridExtra)
    require(grid)
    require(ggthemes)
    
    # loop para saber si col es un vector con las columnas.
    
    if (length(col)==0){
        ncol  <- 1:ncol(df)
        ncol  <- ncol[-n]    
        
    }
    else{
        ncol  <- col
    }
    
    
    # valiando si la covariable base es categorica o numérica
    
    if (class(df[,n]) == "factor"){
        
        # si es categorica aplicamos:   
        
        for (count in ncol){
            if(class(df[,count]) == "factor"){
                df2 <- as.data.frame(prop.table(table(df[,n],df[,count] )))
                ggp <- ggplot(df2, aes(x=reorder(Var1,Freq), y=Freq)) +
                    geom_bar(stat='identity', fill="darkred",color="black") +
                    facet_wrap( ~ Var2)+
                    coord_flip()+
                    scale_y_continuous(labels=percent) + 
                    theme_solarized_2() +
                    ggtitle(names(df)[count])+
                    xlab(names(df)[n])+
                    geom_text(aes(label=paste((Freq)*100,"%")), vjust=-.25,hjust=.98,colour="white")
                
            }
            else{
                des  <- "..density.."
                des2 <- "-..density.."
                ggp <-  ggplot(df, aes_string(x = names(df)[count])) +
                    #y=names(df)[count])) +
                    stat_density(aes_string(ymax = des,  
                                            ymin = des2
                                            #,fill=names(df)[n],color = names(df)[n]
                    ),
                    geom = "ribbon", position = "identity"
                    ) +
                    #geom_violin(alpha=0.5, color="gray")+
                    #geom_jitter(alpha=0.5, aes(color=names(df)[n]),                                                 
                    #            position = position_jitter(width = 0.1))+
                    facet_grid(as.formula(sprintf('. ~%s',names(df)[n]))) +
                    #coord_flip() +
                    scale_y_continuous(labels=percent) +
                    theme(legend.position = "none")+
                    theme_solarized_2() +
                    ggtitle(paste(names(df)[count], " vs. ", names(df)[n]))
                # + annotation_custom(grobTree(textGrob(
                #    paste("Q-25% = ",
                #          as.vector(quantile(df[,count],na.rm=T)[2]),
                #          ",  Q-50% = ",
                #          as.vector(quantile(df[,count],na.rm=T)[3]),
                #          ",  Q-75% =",as.vector
                #          (quantile(df[,count],na.rm=T)[4])),
                #    x=0.1,  y=0.97, hjust=0, 
                #    gp=gpar(col="black", fontsize=13, 
                #                    fontface="italic"))))
                
                
            }
            plot(ggp)
        }
    }
    else{
        # si la viariable base es numerica:
        for (count in ncol){
            if(class(df[,count]) == "factor"){
                ggp <-  ggplot(df, aes_string(x = names(df)[count], 
                                              y=names(df)[n])) +
                    #stat_density(aes(ymax = ..density..,  
                    #ymin = -..density..,
                    #fill="gray"),
                    #color = names(df)[count]),
                    #geom = "ribbon", position = "identity") +
                    geom_violin(alpha=0.5, color="gray")+
                    geom_jitter(alpha=0.5, 
                                #aes_string(color=names(df)[count]),                                                 
                                position = position_jitter(width = 0.1))+
                    #facet_wrap(as.formula(sprintf(' ~%s',
                    #names(df)[count])))+
                    theme_solarized_2() +
                    #scale_colour_solarized("blue")+
                    coord_flip() +
                    #scale_y_continuous(labels=percent) +
                    theme(legend.position = "none")+
                    ggtitle(paste(names(df)[n], " vs. ", names(df)[count]))
                
            }
            else{
                ggp  <- ggplot(df,aes_string(x = names(df)[n], y = names(df)[count])) +
                    geom_smooth(method="lm", colour="darkred", se=F,level=0.90) + 
                    geom_point(colour="steelblue") +
                    theme_economist()+
                    ggtitle(paste("correlación = ", round(cor(df[n],df[count], use="na.or.complete")[1],2)))
                
            }
            plot(ggp)
        }
        
    }
}

#Ejemplo con el dataframe=algas.data, con la columna base V1, la cual es una
#variable categórica. y se compara contra todas las otras columnas.



#eda2(algas.data,1)

#eda2(algas.data,1,c(2,6))


# Si queremos remover las que tengan más del 20% de NAs...
#algas <- algas[-indicesConNAs(algas, 0.2),]

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


# Normalizar los nombres de las variables.
# ver el paquete library(rattle), su función nomVarNames

# Función:
normalizarNombres <- function(df.colnames) {
    
    require(stringr)
    
    
    df.colnames <- str_replace_all(df.colnames,"([[:punct:]])|\\s+",".")
    df.colnames <- gsub("([a-z])([A-Z])", "\\1.\\L\\2", df.colnames, 
                        perl = TRUE)
    df.colnames  <- sub("^(.[a-z])", "\\L\\1", df.colnames, perl = TRUE)
    df.colnames  <- tolower(df.colnames)
}


normalizar  <- function(data){
    df  <- data.frame()
    for (n in 1:ncol(data)){
        if(class(data[,n])=="numeric"){
            data$n  <- (data[,n]-mean(data[,n],na.rm=T))/sd(data[,n],na.rm=T)
            
        }
    }
}


# Imputa los valores faltantes por los pesos promedios de los valores  de los K vecinos
#library(DMwR)

# knnImputation(df,K=10,meth='weighAvg')


