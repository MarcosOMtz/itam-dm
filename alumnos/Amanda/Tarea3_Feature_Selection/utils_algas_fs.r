# Filtrado basado en las propiedades de la distribución

low.variability <- function(base, porcen){
  # Obtenemos las medianas
  medianas <- laply(base, function(x) round(median(x, na.rm = TRUE), digits = 3))

  # Obtenemos el IQR
  cuartil_1 <- laply(base, function(x) round(quantile(x, 0.25, na.rm = TRUE),  digits = 3))
  cuartil_3 <- laply(base, function(x) round(quantile(x, 0.75, na.rm = TRUE),  digits = 3))
  medidas <- data.frame(variable = names(base), medianas, cuartil_1, cuartil_3, iqr = cuartil_3 - cuartil_1)

  # Obtenemos gráfica para ver la distribución de las variables
  grafica <- ggplot(medidas, aes(x = medianas, y = iqr)) +
              geom_point()

  # Verificamos que variables serían filtradas
  baja_varia <- laply(medidas[,'iqr'], function(x) x < porcen*mean(medidas[,'iqr']))
  filtra_names <- which(ifelse(baja_varia == TRUE, TRUE, FALSE))
  filtra_variables <- names(base[,filtra_names])
  filtra_variables
}

# Correlation Filtering

correlation.filtering <- function(base, correla){
  vars.cor <- cor(base, use = 'complete.obs')
  vars.cor[upper.tri(vars.cor, diag = TRUE)] <- NA
  
  vars.cor <- vars.cor %>%
    abs() %>%   
    data.frame() %>%
    mutate(var1 = row.names(vars.cor)) %>%
    gather(var2, cor, -var1) %>%
    na.omit()
  
  vars.cor <- vars.cor[order(-abs(vars.cor$cor)),]
  muy.cor <- filter(vars.cor, cor > correla) 
  filtra_variables <- muy.cor$var2
  filtra_variables
}

# Fast correlation - based filtering

FCB.filtering<- function(base, base_target){
  filtra_variables <- ""
  # Obtenemos la variable mas correlacionada con la variable target
  cor_target <- cor(x = base, y = base_target, use = "complete.obs")
  cor_target <- data.frame(var1 = row.names(cor_target), cor = abs(cor_target[,1])) 
  mas.cor <- as.matrix(filter(cor_target, cor == max(cor)))
  mas.name <- mas.cor[1,1]
  resto.cor <- as.matrix(filter(cor_target, cor != max(cor)))
  resto.names <- resto.cor[,1]
  base_mas <- base[mas.name]
  base_resto <- base[resto.names]
  # Obtenemos las variables más correlacionadas conm la variable elegida
  cor_mas <- cor(x = base_resto, y = base_mas, use = "complete.obs")
  cor_mas <- data.frame(var1 = row.names(cor_mas), cor = abs(cor_mas[,1])) 
  mas.cor.nvo <- as.matrix(filter(cor_mas, cor >= 0.90))
  filtrar <- as.vector(mas.cor.nvo[,1])
  if (length(filtrar) != 0){
    filtra_variables <- as.vector(mas.cor.nvo[,1])
  }
  # Repetimos el proceso sin las variables filtradas y sin la variable más correlaiconada
  vars_no <- union(mas.name, filtra_variables)
  vars <- setdiff(names(base), vars_no)
  base1 <- base[vars]
  cor1_target <- cor(x = base1, y = base_target, use = "complete.obs")
  cor1_target <- data.frame(var1 = row.names(cor1_target), cor = abs(cor1_target[,1])) 
  mas1.cor <- as.matrix(filter(cor1_target, cor == max(cor)))
  mas1.name <- mas1.cor[1,1]
  resto1.cor <- as.matrix(filter(cor1_target, cor != max(cor)))
  resto1.names <- resto1.cor[,1]
  base1_mas <- base[mas1.name]
  base1_resto <- base[resto1.names]
  # Obtenemos las variables más correlacionadas conm la variable elegida
  cor1_mas <- cor(x = base1_resto, y = base1_mas, use = "complete.obs")
  cor1_mas <- data.frame(var1 = row.names(cor1_mas), cor = abs(cor1_mas[,1])) 
  mas1.cor_nvo <- as.matrix(filter(cor1_mas, cor >= 0.90))
  filtrar1 <- as.vector(mas1.cor_nvo[,1])
  if (length(filtrar1) != 0){
    filtra_variables <- union(filtra_variables, filtra1)
  }
  filtra_variables
}

# Forward selection

forward.filtering <- function(base, base_target){
  base_com <- data.frame(base, target = base_target)
  # Obtenemos la regresión con cada variable
  indices_regre <- which(apply(base_com, 1, function(x) sum(is.na(x))) > 0)
  base_regre <- base_com[-indices_regre,]
  no_mod <- length(base_regre) - 1
  no_target <- length(base_regre)
  datos <- matrix(nrow = no_mod, ncol = 3)
  #Guardamos los valores del p-value y r cuadrada
  for (i in 1:no_mod){
    var_ind <- names(base_regre)[i]
    regre <- summary(lm(base_regre[,no_target] ~ base_regre[,var_ind]))
    datos[i, 1] <- var_ind
    datos[i, 2] <- regre$coeff[2,4]
    datos[i, 3] <- regre$r.squared
  }
  # Seleccionamoes los modelos de las variables significativas
  df_1 <- as.data.frame(datos)
  df_1$V2 <- as.numeric(as.character(df_1$V2))
  df_1$V3 <- as.numeric(as.character(df_1$V3))
  var_signi <- filter(df_1, V2 < 0.05)
  # Seleccionamos el modelo con r cuadrada más alta
  var_selec_a <- filter(var_signi, V3 == max(V3))
  var_selec <- as.character(var_selec_a$V1)
  r_cua <- var_selec_a$V3

############
  
  # Repetimos el modelo con la variable seleccionada
  vars <- setdiff(names(base_regre), var_selec)
  base_regre1 <- base_regre[,vars] 
  # Obtenemos la regresión con cada variable
  no_mod1 <- length(base_regre1)-1
  datos1 <- matrix(nrow = no_mod1, ncol = 4)
  #Guardamos los valores del p-value y r cuadrada
  for (i in 1:no_mod1){
    var_ind1 <- names(base_regre1)[i]
    regre1 <- summary(lm(base_regre[,no_target] ~ base_regre[,var_selec] + base_regre[,var_ind1]))
    datos1[i, 1] <- var_ind1
    datos1[i, 2] <- regre1$coeff[2,4]
    datos1[i, 3] <- regre1$coeff[3,4]
    datos1[i, 4] <- regre1$r.squared
  }
  # Seleccionamoes los modelos de las variables significativas
  df_2 <- as.data.frame(datos1)
  df_2$V2 <- as.numeric(as.character(df_2$V2))
  df_2$V3 <- as.numeric(as.character(df_2$V3))
  df_2$V4 <- as.numeric(as.character(df_2$V4))
  var_signi1 <- filter(df_2, V3 < 0.05)
  # Seleccionamos el modelo con r cuadrada más alta
  var_selec_a1 <- filter(var_signi1, V4 == max(V4))
  var_selec1 <- as.character(var_selec_a1$V1)
  r_cua1 <- var_selec_a1$V4
  
##########
  
  # Si la r cuadrada del nuevo modelo es mayor a la del anterior se seleccionan las dos variables para un nuevo modelo
  if (r_cua < r_cua1){
    gru_var_selec <- c(var_selec, var_selec1)
    # Repetimos el modelo con la variable seleccionada
    vars2 <- setdiff(names(base_regre), gru_var_selec)
    base_regre2 <- base_regre[,vars2] 
    # Obtenemos la regresión con cada variable
    no_mod2 <- length(base_regre2) - 1
    datos2 <- matrix(nrow = no_mod2, ncol = 5)
    #Guardamos los valores del p-value y r cuadrada
    for (i in 1:no_mod2){
      var_ind2 <- names(base_regre2)[i]
      regre2 <- summary(lm(base_regre[,no_target] ~ base_regre[,var_selec] + base_regre[,var_selec1] + base_regre[,var_ind2]))
      datos2[i, 1] <- var_ind2
      datos2[i, 2] <- regre2$coeff[2,4]
      datos2[i, 3] <- regre2$coeff[3,4]
      datos2[i, 4] <- regre2$coeff[4,4]
      datos2[i, 5] <- regre2$r.squared
    }
    # Seleccionamoes los modelos de las variables significativas
    df_3 <- as.data.frame(datos2)
    df_3$V2 <- as.numeric(as.character(df_3$V2))
    df_3$V3 <- as.numeric(as.character(df_3$V3))
    df_3$V4 <- as.numeric(as.character(df_3$V4))
    df_3$V5 <- as.numeric(as.character(df_3$V5))
    var_signi2 <- filter(df_3, V4 < 0.05)
    # Seleccionamos el modelo con r cuadrada más alta
    var_selec_a2 <- filter(var_signi2, V5 == max(V5))
    var_selec2 <- as.character(var_selec_a2$V1)
    r_cua2 <- var_selec_a2$V5
    }
  #if (r_cua1 < r_cua2){
    # requiere más código
  #}
  filtra_variables <- ""
  filtra_variables
}

# Epsilon

epsilon_categorica <- function(base, clase, proba){
  nx <- length(base)
  frec <- table(base)[clase] / nx
  epsilon <- (nx * (frec - proba))/(nx * proba * (1-proba))
  epsilon
  #filtra_variables
}

epsilon_numerica <- function(base, media, varianza){
  x_i <- mean(base, na.rm = TRUE)
  var_i <- (sd(base, na.rm = TRUE))^2
  epsilon <- (x_i - media) / (var_i - varianza)
  epsilon
  #filtra_variables
}
