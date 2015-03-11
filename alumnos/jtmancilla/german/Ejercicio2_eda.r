source("0-load.r")
source("2-eda.r")
library(corrgram)

german.data  <- load()

summary(german.data)
str(german.data)


View(german.data)

# Visualización 
eda1(german.data,4)


# tomando como variable objetivo good.loan

eda2(german.data,21,4)


# visualización de NA`s

na_german <- as.data.frame(abs(is.na(german.data)))
sort(colSums(na_german),decreasing=T)
sort(colMeans(na_german*100),decreasing=T)



