# Función para verificar si ya existe la base en nuestra carpeta y cargar los datos

load <- function(name, path, url){
  if (file.exists(name) == FALSE){
    # En caso de que no exista la base de datos la descargamos y guardamos
    base <- read.table(url, stringsAsFactors = FALSE, header = FALSE, sep = '', na.strings = c('XXXXXXX'))
    saveRDS(base, paste(name, '.rds', sep = ''))
  }
  else{
    # Si la base ya existe en la carpeta la leemos
    base <- readRDS(name)
  }
  base
}

# Función para dar formato a los nombres

normalizarNombres <- function(nombres){
  nombres <- str_replace_all(nombres, ' ', '.')
  nombres <- str_replace_all(nombres, '/', '.')
  nombres <- str_replace_all(nombres, '-', '.')
  nombres <- str_replace_all(nombres, '_', '.')
  nombres <- str_replace_all(nombres, 'ñ', 'ni')
  nombres <- tolower(nombres)
  nombres
}

# Función para definir variables categóricas como factores

factorClass <- function(base){
  tipos <- lapply(base, function(x) class(x))
  i <- which(ifelse(tipos == 'character', TRUE, FALSE))
  base[i] <- lapply(base[i], function(x) as.factor(x))
  base
}

# Función para obtener gráficas de una variable numérica

graficaNum <- function(base, x1){
    
  grafica_0a <- ggplot(base, aes(x = base$id, y = base[,x1]))
  grafica_0b <- ggplot(base, aes(x = base[,x1]))
    
  # Box-plot
  grafica_1 <- grafica_0a + 
  geom_boxplot(fill = '#3399CC', colour = 'black', outlier.colour = 'red', outlier.size = 3) +
  ggtitle(paste('Box-plot ', names(base)[x1])) + 
  scale_y_continuous(name = '') + 
  scale_x_continuous(name = '', breaks = NULL) +
  theme(plot.title = element_text(lineheight = .8, face = 'bold'))
      
  # Histograma
  grafica_2 <- grafica_0b + 
  geom_histogram(fill = '#33CC99', colour = 'black') +
  ggtitle(paste('Histograma ', names(base)[x1])) + 
  scale_x_continuous(name = '') +
  theme(plot.title = element_text(lineheight = .8, face = 'bold'))
    
  # Dot-plot
  grafica_3 <- grafica_0b + 
  geom_dotplot(stackdir = 'centerwhole', fill = '#CC99CC') +
  ggtitle(paste('Dot-plot ', names(base)[x1])) + 
  scale_x_continuous(name = '') +
  theme(plot.title = element_text(lineheight = .8, face = 'bold'))
      
  # Violin-plot
  grafica_4 <- grafica_0a + 
  geom_violin(fill = '#FF9966') +
  ggtitle(paste('Violin-plot ', names(base)[x1])) + 
  scale_y_continuous(name = '') + 
  scale_x_continuous(name = '', breaks = NULL) +
  theme(plot.title = element_text(lineheight = .8, face = 'bold'))
    
  # Densidad
  grafica_5 <- grafica_0b + 
    geom_histogram(aes(y = ..density..), fill = '#FFFFCC', colour = 'black') + 
    geom_density(color = 'red') +
    ggtitle(paste('Densidad ', names(base)[x1])) + 
    scale_x_continuous(name = '') +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'))
  
  # QQ-plot
  
  # Variables que nos serviran para la qqline
  yy <- quantile(base[,x1][!is.na(base[,x1])], c(0.25, 0.75))
  xx <- qnorm(c(0.25, 0.75))
  slope <- diff(yy) / diff(xx)
  int <- yy[1L] - slope * xx[1L]
  
  # Generamos la gráfica qqnorm y qqline
  grafica_6 <- ggplot(base, aes(sample = base[,x1])) +
    ggtitle(paste('QQ-plot ', names(base)[x1])) + 
    stat_qq(shape = 1, size = 4) +
    geom_abline(slope = slope, intercept = int, colour = 'red', size = 1) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'))
  
  # Presentamos las gráficas en la misma pantalla
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(2, 3)))
  vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
  print(grafica_1, vp = vplayout(1, 1))
  print(grafica_2, vp = vplayout(1, 2))
  print(grafica_3, vp = vplayout(1, 3))
  print(grafica_4, vp = vplayout(2, 1))
  print(grafica_5, vp = vplayout(2, 2))
  print(grafica_6, vp = vplayout(2, 3))
}

# Función para obtener gráficas de una variable categórica

graficaFac <- function(base, x1){
  agrupa<- group_by(base, base[,x1])
  conteo_agrupa <- summarise(agrupa, n = n())
  fac.base <- as.data.frame(conteo_agrupa)
  colnames(fac.base) <- c('variable', 'n')
  fac.base <- mutate(fac.base, frec.rela = n*100/sum(n))
  grafica_0a <- ggplot(fac.base, aes(x = reorder(variable, n), y = n, fill = variable)) 
  grafica_0b <- ggplot(fac.base, aes(x = reorder(variable, frec.rela), y = frec.rela, fill = variable))
  
  # Barras
  grafica_1 <- grafica_0a + 
    geom_bar(stat = 'identity') +
    coord_flip() +
    ggtitle(paste('No. de casos', names(base)[x1])) +
    scale_x_discrete(name = '') +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'), legend.position = 'none')
  
  # Freecuencias relativas
  grafica_2 <- grafica_0b + 
    geom_bar(stat = 'identity') +
    coord_flip() +
    ggtitle(paste('Porcentajes', names(base)[x1])) +
    scale_x_discrete(name = '') +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'), legend.position = 'none')
  
  # Presentamos las gráficas en la misma pantalla
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(1, 2)))
  vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
  print(grafica_1, vp = vplayout(1, 1))
  print(grafica_2, vp = vplayout(1, 2))
}

# Función para obtener gráficas de dos variables categóricas

graficaFac_Fac <- function(base, x1, x2){
  
  # Stacked bar chart
  agrupa<- group_by(base, base[,x1], base[,x2])
  conteo_agrupa <- summarise(agrupa, n = n())
  fac.base <- as.data.frame(conteo_agrupa)
  colnames(fac.base) <- c('x1', 'x2', 'n')
  
  grafica_0a <-  ggplot(base, aes(x = base[,x1], fill = base[,x2]))
  grafica_0b <-  ggplot(base, aes(x = base[,x2], fill = base[,x1]))
  
  grafica_1 <- grafica_0a + 
    geom_bar() +
    ggtitle('Stacked bar chart') +
    scale_x_discrete(name = names(base)[x1]) +
    scale_fill_discrete(name = names(base)[x2]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'))
  
  grafica_2 <- grafica_0b + 
    geom_bar() +
    ggtitle('Stacked bar chart') +
    scale_x_discrete(name = names(base)[x2]) +
    scale_fill_discrete(name = names(base)[x1]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'))
  
  grafica_3 <- grafica_0a + 
    geom_bar(position = 'fill') +
    ggtitle('Stacked bar chart') +
    scale_x_discrete(name = names(base)[x1]) +
    scale_fill_discrete(name = names(base)[x2]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'))
  
  grafica_4 <- grafica_0b + 
    geom_bar(position = 'fill') +
    ggtitle('Stacked bar chart') +
    scale_x_discrete(name = names(base)[x2]) +
    scale_fill_discrete(name = names(base)[x1]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'))
  
  # Presentamos las gráficas en la misma pantalla
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(2, 2)))
  vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
  print(grafica_1, vp = vplayout(1, 1))
  print(grafica_2, vp = vplayout(1, 2)) 
  print(grafica_3, vp = vplayout(2, 1))
  print(grafica_4, vp = vplayout(2, 2))
}

# Función para obtener gráficas de variable categórica y variable numérica

graficaFac_Num <- function(base, x1, x2){
  
  grafica_0a <- ggplot(ds, aes(x = base[,x1], y = base[,x2]))
  
  # Box-plot
  grafica_1 <- grafica_0a + 
    geom_boxplot(aes(fill = base[,x1]), outlier.colour = 'red', outlier.size = 3) +
    ggtitle('Box-plot') + 
    scale_y_continuous(name = names(base)[x2]) + 
    scale_x_discrete(name = names(base)[x1]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'), legend.position = 'none')
  
  # Violin-plot
  grafica_2 <- grafica_0a + 
    geom_violin(aes(fill = base[,x1])) +
    ggtitle('Violin-plot') + 
    scale_y_continuous(name = names(base)[x2]) + 
    scale_x_discrete(name = names(base)[x1]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'), legend.position = 'none')
  
  # Dot-plot
  grafica_3 <- grafica_0a + 
    geom_dotplot(aes(fill = base[,x1]), binaxis = 'y', stackdir = 'center', binpositions = 'all') +
    ggtitle('Dot-plot') + 
    scale_y_continuous(name = names(base)[x2]) + 
    scale_x_discrete(name = names(base)[x1]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'), legend.position = 'none')
  
  # Presentamos las gráficas en la misma pantalla
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(2, 2)))
  vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
  print(grafica_1, vp = vplayout(1, 1))
  print(grafica_2, vp = vplayout(1, 2))
  print(grafica_3, vp = vplayout(2, 1:2)) 
}

# Función para obtener gráficas de variable numérica y variable categorica

graficaNum_Fac <- function(base, x1, x2){
  
  grafica_0a <- ggplot(base, aes(x = base[,x2], y = base[,x1]))
  
  # Box-plot
  grafica_1 <- grafica_0a + 
    geom_boxplot(aes(fill = base[,x2]), outlier.colour = 'red', outlier.size = 3) +
    ggtitle('Box-plot') + 
    scale_y_continuous(name = names(base)[x1]) + 
    scale_x_discrete(name = names(base)[x2]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'), legend.position = 'none')
  
  # Violin-plot
  grafica_2 <- grafica_0a + 
    geom_violin(aes(fill = base[,x2])) +
    ggtitle('Violin-plot') + 
    scale_y_continuous(name = names(base)[x1]) + 
    scale_x_discrete(name = names(base)[x2]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'), legend.position = 'none')
  
  # Dot-plot
  grafica_3 <- grafica_0a + 
    geom_dotplot(aes(fill = base[,x2]), binaxis = 'y', stackdir = 'center', binpositions = 'all') +
    ggtitle('Dot-plot') + 
    scale_y_continuous(name = names(base)[x1]) + 
    scale_x_discrete(name = names(base)[x2]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'), legend.position = 'none')
  
  # Presentamos las gráficas en la misma pantalla
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(2, 2)))
  vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
  print(grafica_1, vp = vplayout(1, 1))
  print(grafica_2, vp = vplayout(1, 2))
  print(grafica_3, vp = vplayout(2, 1:2))   
}

# Función para obtener gráficas de dos variables numéricas

graficaNum_Num <- function(base, x1, x2){
  
  grafica_0a <- ggplot(base, aes(x = base[,x1], y = base[,x2]))
  grafica_0b <- ggplot(base, aes(x = log(base[,x1]), y = log(base[,x2])))
  
  # Scatter-plot
  grafica_1 <- grafica_0a +
    geom_point(colour = 'blue') +
    ggtitle('Scatter-plot') + 
    scale_y_continuous(name = names(base)[x2]) + 
    scale_x_continuous(name = names(base)[x1]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'))
  
  grafica_2 <- grafica_0b +
    geom_point(colour = 'blue') +
    ggtitle('Scatter-plot (logaritmos)') +
    scale_y_continuous(name = names(base)[x2]) + 
    scale_x_continuous(name = names(base)[x1]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'))
  
  # Density 2d
  grafica_3 <- grafica_0a + 
    geom_point() +
    geom_density2d() +
    ggtitle('Density 2d') +
    scale_y_continuous(name = names(base)[x2]) + 
    scale_x_continuous(name = names(base)[x1]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'))
  
  grafica_4 <- grafica_0b + 
    geom_point() +
    geom_density2d() +
    ggtitle('Density 2d (logaritmos') +
    scale_y_continuous(name = names(base)[x2]) + 
    scale_x_continuous(name = names(base)[x1]) +
    theme(plot.title = element_text(lineheight = .8, face = 'bold'))
  
  # Presentamos las gráficas en la misma pantalla
  grid.newpage()
  pushViewport(viewport(layout = grid.layout(2, 2)))
  vplayout <- function(x, y) viewport(layout.pos.row = x, layout.pos.col = y)
  print(grafica_1, vp = vplayout(1, 1))
  print(grafica_2, vp = vplayout(1, 2))
  print(grafica_3, vp = vplayout(2, 1)) 
  print(grafica_4, vp = vplayout(2, 2))
}

# Función para identificar las observaciones con x porcentaje de NA's

indicesConNAs <- function(base, porcentaje){
  n <- if (porcentaje < 1){
    as.integer(porcentaje * ncol(base))
  } else {
    stop('Debes introducir el porcentaje de columnas con NAs')
  }
  indices <- which(apply(base, 1, function(x) sum(is.na(x))) > n)
  if (!length(indices)){
    warning('No hay observaciones con ese porcentaje de NAs')
  }
  indices
}

# Función para omitir las observaciones con muchos NAs

omitirObserva <- function(base, observa.omitidas){
  if (length(observa.omitidas) > 0){
    base <- base[-observa.omitidas,]
  }
  base
}

# Función para imputación de variables categóricas

imputaCate <- function(base1, base2, ids_na){
  for (i in ids_na){
    x1 <- i
    nas <- which(is.na(base1[,x1]))
    base2[nas, x1] <- 'missing'
  }
  base2
}

# Función para imputación por valor Central de variables numéricas

imputaNumeCentral <- function(base1, base2, ids_na){
  for (i in ids_na){
    x1 <- i
    nas <- which(is.na(base1[,x1]))
    valor.imputado <- mean(base1[,x1], na.rm=TRUE)
    base2[nas, x1] <- valor.imputado
  }
  base2
}

# Función para imputación por Correlación de variables numéricas

imputaNumeCorrela <- function(base1, base2, ids_na, correla){
  indices_regre <- which(apply(base2, 1, function(x) sum(is.na(x))) > 0)
  base_regre <- base2[-indices_regre,]
  k <- 0
  for (i in ids_na){
    x1 <- i
    k <- k + 1
    j = correla[k]
    nas <- which(is.na(base1[,x1]))
    regre <- lm(base_regre[,x1] ~ base_regre[,j], data = base_regre)
    inter <- coefficients(summary(regre))[1]
    coefi <- coefficients(summary(regre))[2]
    base2[nas, x1] <- inter + coefi*base2[nas, j]
  }
  base2
}

# Función para imputación por Similitud variables numéricas

imputaNumeSimil <- function(base1, base2, ids_na){
  j <- 0
  for (i in ids.nas.numericas){
    x1 <- i
    j <- j + 1
    nas <- which(is.na(base1[,x1]))
    base_simil <- base1[ids.nas.numericas]
    base_simil <- base_simil[-j]
    distancia <- matrix(0, ncol = 2, nrow = nrow(base_simil))
    for (p in nas){
      for (k in 1:nrow(base_simil)){
        distancia[k, 2] <- sqrt(sum((base_simil[p,] - base_simil[k,])^2))
        distancia[k, 1] <- k
      }
      distancia[p, 2] <- NA
      m <- which.min(distancia[,2])
      if (sum(m) != 0){
      base2[p, x1] <- base2[m, x1]
      }
    }
  }
  base2
}