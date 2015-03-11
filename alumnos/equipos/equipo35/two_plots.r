two_numerical <- function(df){
    if (dim(df)[2] > 2){
        stop("Esta funcion esta hecha para recibir solamente dos variables.")
    }
    s <- ggplot(df, aes_string(x=names(df)[1], y=names(df)[2])) + geom_point() +
        labs(x=names(df)[1], y=names(df)[2]) +
        ggtitle(paste0("Gráfico de dispersión de ", names(df)[1], " y ", names(df)[2])) +
        stat_smooth(method = "loess", formula = y ~ x, size = 1)
    s
}

numerical_categorical <- function(df){
    if (dim(df)[2] > 2){
        stop("Esta funcion esta hecha para recibir solamente dos variables.")
    }
    # Forzamos a que el factor este en el lugar 1.
    if(class(df[,1])=="numeric" | class(df[,1])=="integer"){
        df <- df[,c(2,1)]
    }
    # Boxplot
    box <- ggplot(df, aes_string(x=names(df)[1], y=names(df)[2])) + geom_boxplot() +
        labs(x=names(df)[1], y=names(df)[2]) +
        ggtitle(paste0("Diagrama de caja y brazos de ", names(df)[2], " sobre ", names(df)[1]))

    # Density x categoria
    density <- ggplot(df, aes_string(x=names(df)[2], colour = names(df)[1])) + geom_density() +
        ggtitle(paste0("Gráficos de densidad de ", names(df)[2], " sobre ", names(df)[1]))

#     # Histograma con facet
#     hist <- ggplot(df, aes_string(x=names(df)[2])) + geom_bar() + facet_wrap(~ df[,1])
#     hist
    return(list(box=box,density=density))
}

cat_cat <- function(df){
    if (dim(df)[2] > 2){
        stop("Esta funcion esta hecha para recibir solamente dos variables.")
    }
    sbar <- ggplot(data=df, aes_string(x=names(df)[1], fill=names(df)[2])) +
        geom_bar() +
        ggtitle(paste0("Barras apiladas de ", names(df)[2], " sobre ", names(df)[1]))
    sbar
}

two_plots <- function(df, vector=names(df)){
    # Recibe un dataframe y un vector de nombres.
    # Regresa graficos para combinaciones de pares de variables incluidas en el vector.
    df <- df[,names(df) %in% vector]
    cols <- dim(df)[2]
    if(cols <= 1){
        stop("Debe haber mas de dos columnas")
    }
    for (i in c(1:(cols-1))){
        for(j in c((i+1):cols)){
            df2 <- df[, c(i,j)]
            if(all(sapply(df2,class, simplify="array") %in% c('factor','factor'))){
                print(cat_cat(df2))
            }
            if(all(c('factor','numeric') %in% sapply(df2,class, simplify="array"))){
                #print(i)
                #print(j)
                print(numerical_categorical(df2))
            }
            if(all(sapply(df2,class, simplify="array") %in% c('numeric','numeric'))){
                print(two_numerical(df2))
            }
        }
    }
}