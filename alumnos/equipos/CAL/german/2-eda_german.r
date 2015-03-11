# Obtenemos las gráficas por variable utilizando las funciones graficaNum y graficaFac

base <- ds.original
grafi_una <- c(1:length(base))

for (i in grafi_una){
  x1 <- i
  if (names(base[x1]) != 'id'){
    class <- class(base[,x1])
    if (class == 'factor'){
      graficas <- graficaFac(base, x1)
    }
    else if ((class == 'numeric') || (class == 'integer')){
      graficas <- graficaNum(base, x1)
    }
    graficas
  }
}


# Definimos el número de combinaciones que se ejecutaran para las gráficas de dos variables

base <- select(ds.original, -id)
no_var <- ncol(base)
combina <- as.data.frame(combn(no_var,2))
grafi_par <- (1:length(combina))

# Obtenemos las gráficas utilizando las funciones graficaFac_Fac, graficaFac_Num, graficaNum_Fac y graficaNum_Num 

for (i in grafi_par){  
  x1 <- combina[1,i]
  x2 <- combina[2,i]
  class_x1 <- class(base[,x1])
  class_x2 <- class(base[,x2])
  if ((class_x1 == 'factor') & (class_x2 == 'factor')){
    graficas <- graficaFac_Fac(base, x1, x2)
  }
  else if ((class_x1 == 'factor') & (class_x2 == 'numeric' || class_x2 == 'integer')){
    graficas <- graficaFac_Num(base, x1, x2)
  }
  else if ((class_x1 == 'numeric' || class_x1 == 'integer') & (class_x2 == 'factor')){
    graficas <- graficaNum_Fac(base, x1, x2)
  }
  else if((class_x1 == 'numeric' || class_x1 == 'integer') & (class_x2 == 'numeric' || class_x2 == 'integer')){
    graficas <- graficaNum_Num(base, x1, x2)
  }
  graficas
}
