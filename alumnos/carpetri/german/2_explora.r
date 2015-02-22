

#source('0_load_data.r')
#source('1_prepare_data.R')

ls()

matrix_cor_nas(german.data)

# corplot
# corrgram

df <- german.data
names(df)
x <- as.data.frame(abs(is.na(df))) 
head(df)
head(x)

# Extrae las variables que tienen algunas celdas con NAs
y <- x[which(sapply(x, sd) > 0)] 
y

# Da la correación un valor alto positivo significa que desaparecen juntas.
cor(y) 
