# === Tarea 01 ===

# Generramos la funcion para obtener la base de datos de German
load  <-  function() {
  if (file.exists('german.rds')) {
    german.data <- readRDS('german.rds')
    german.data
  }
  else {
    german.url <- paste('http://archive.ics.uci.edu/ml',
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

# Cargamos la base de datos de German
german.data <- load()



# Cargamos las librerias necesarias
library(plyr)
library(dplyr)
library(ggplot2)
library(gridExtra)


# Reasignamos nombres de las columnas (letras minusculas,
#                                      sustituyendo la diagonal y espacios en blanco por puntos)

# Creamos la funcion para la reasignacion
german.colnames <- c('Status of existing checking account',
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

library(stringr)

german.colnames <- str_replace_all(german.colnames,"([[:punct:]])|\\s+",".")
german.colnames <- tolower(german.colnames)
head(german.colnames)


# Aplicamos la funcion a los datos
colnames(german.data) <- german.colnames
View(german.data)


# Haciendo factor a la columna good.loan
german.data$good.loan <- as.factor(
  ifelse (german.data$good.loan == 1,
          'GoodLoan',
          'BadLoan'
          )
)

# Viendo los resultados
head(german.data$good.loan)
View(german.data)


# Codificando los valores de las columnas
# Utilizando los datos proporcionados para re-codificar los valores de las columnas
german.codes <- list('A11'='... < 0 DM',
                     'A12'='0 <= ... < 200 DM', 
                     'A13'='... >= 200 DM / salary assignments for at least 1 year',
                     'A14'='no checking account', 
                     'A30'='no credits taken/all credits paid back duly',
                     'A31'='all credits at this bank paid back duly', 
                     'A32'='existing credits paid back duly till now',
                     'A33'='delay in paying off in the past', 
                     'A34'='critical account/other credits existing (not at this bank)',
                     'A40'='car (new)', 
                     'A41'='car (used)', 
                     'A42'='furniture/equipment',
                     'A43'='radio/television', 'A44'='domestic appliances', 'A45'='repairs',
                     'A46'='education', 'A47'='(vacation - does not exist?)',
                     'A48'='retraining', 'A49'='business', 'A410'='others', 'A61'='... < 100 DM',
                     'A62'='100 <= ... < 500 DM', 'A63'='500 <= ... < 1000 DM',
                     'A64'='.. >= 1000 DM', 'A65'='unknown/ no savings account',
                     'A71'='unemployed', 'A72'='... < 1 year', 'A73'='1 <= ... < 4 years', 
                     'A74'='4 <= ... < 7 years', 'A75'='.. >= 7 years', 'A91'='male : divorced/separated',
                     'A92'='female : divorced/separated/married',
                     'A93'='male : single',
                     'A94'='male : married/widowed', 
                     'A95'='female : single',
                     'A101'='none', 
                     'A102'='co-applicant',
                     'A103'='guarantor', 'A121'='real estate',
                     'A122'='if not A121 : building society savings agreement/life insurance',
                     'A123'='if not A121/A122 : car or other, not in attribute 6',
                     'A124'='unknown / no property', 
                     'A141'='bank', 'A142'='stores',  'A143'='none', 'A151'='rent', 'A152'='own',
                     'A153'='for free', 'A171'='unemployed/ unskilled - non-resident',
                     'A172'='unskilled - resident', 'A173'='skilled employee / official',
                     'A174'='management/ self-employed/highly qualified employee/ officer',
                     'A191'='none', 'A192'='yes, registered under the customers name',
                     'A201'='yes', 'A202'='no')


# Generamos la funcion de german.decode
german.decode  <-  function(data,list) {
  # list = list(a = A, b = B, c=C, etc.)
  originales  <- names(data.frame(list))
  # deben ser caracteres y no factores
  nuevos  <- as.vector(unname(unlist(data.frame(list)[1,])))
  # múltiples columnas usando mutate_each
  data %>% mutate_each(funs(mapvalues(., from = originales, to = nuevos)))
}


# Aplicamos la funcion "german.decode" y la lista "german.codes"
german.data <- german.decode(german.data, german.codes)



# Exploracion sobre la relacion entre el historial crediticio (crediot.history) y la calificacion
# del acreditado (good.loan)


# Visualizando tabla con resultados
table(german.data$good.loan) # good.loan
table(german.data$credit.history)  # credit.history


# Visualizacion de "credit.history"
# IMPORTANTE: Para que funcionara n() tuve que desactivar la libreria "plyr"
credit.history.df  <- german.data              %>%
                      group_by(credit.history) %>%
                      summarise(count = n())       %>%
                      arrange(desc(count))

# Viendo resultados
credit.history.df


g1  <- ggplot(credit.history.df, aes(x= reorder(credit.history,count), y=count)) +
  geom_bar(stat="identity", fill="steelblue") +
  coord_flip() +
  theme(axis.text.y=element_text(size=rel(0.9))) +
  xlab("Historial de Crédito") + ylab("Numero de créditos")



# Visualizando good.loan
good.loan.df <- german.data %>% count(good.loan)

g2  <- ggplot(good.loan.df, aes(x= reorder(good.loan,n), y=n)) +
  geom_bar(stat="identity", fill="steelblue") +
  xlab("Calificación") + ylab("Numero de créditos")


# Viendo resultados
good.loan.df

# Visualizando los resultados
grid.arrange(g1, g2, nrow=2)


# Visualizando combinando las dos variables calculadas
credit.good.loan  <- german.data                        %>%
                     group_by(credit.history,good.loan) %>%
                     summarise(count = n())

# Viendo resultados
credit.good.loan


g3  <- ggplot(credit.good.loan, aes(x= reorder(credit.history,count), y=count, fill = good.loan)) + 
       geom_bar(stat="identity") + 
       coord_flip() + 
       theme(axis.text.y=element_text(size=rel(0.9)),legend.title=element_blank())+
       xlab("Historial de Crédito") + ylab("Numero de créditos")

g4  <- ggplot(credit.good.loan, aes(x = good.loan, y = count, color =credit.history, group=credit.history)) +
       geom_line() +
       xlab("Calificación") + ylab("Conteo") +
       theme(legend.title=element_blank())


# Visualizando los resultados
grid.arrange(g3, g4, nrow=2)



