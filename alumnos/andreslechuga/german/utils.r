# Funci??n que descarga datos y carga 'german.rds' sii no existe este archivo.
load <- function(){
  german.url <- paste('http://archive.ics.uci.edu/ml',
                      '/machine-learning-databases/statlog',
                      '/german/german.data',
                      sep='')
  if (!file.exists('german.rds')){
    german.data <- read.table(german.url, 
                              stringsAsFactors = FALSE, 
                              header = FALSE)
    saveRDS(german.data, file = 'german.rds')
  }
  readRDS('german.rds')
}

#Nombres de las columnas correspodientes a 'german.rds' y asignaci??n a 'german.colnames'
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
                     'Good.Loan'
)

# Definiendo la variable de salida como variable categ??rica y asignando los nombres de las columnas a 'german.rds'
colnames(german.data) <- german.colnames
german.data$Good.Loan <- as.factor(
  ifelse(
    german.data$Good.Loan == 1, 
    'GoodLoan', 
    'BadLoan'
  )
)

#C??digos de 'german'
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

# Funcion para decodificar los valores de los datos con los de 'german.codes'
german.decode <- function(row, german.codes){
  class <- class(row[,1])
  if(class=='factor'){
    row <- lapply(row, function(x) german.codes[x])
    row <- lapply(row, function(x) as.character(x))
    row <- lapply(row, function(x) as.factor(x))
    row
  }
  else{
    row
  }
}

# aplicar la funcion a cada columna
for (i in 1:20){
  german.data[i] <- german.decode(german[i], german.codes)
}


# Expolrar variables y agrupar los datos para graficar
summary(german.data$Good.Loan)

colnames(german.data) <- gsub(" ",".",colnames(german.data))

tabla <- table(german.data[,'Credit.history'],german.data[,'Good.Loan'] )

tabla2 <- data.frame(tabla)

#Gr??fica
ggplot(tabla2, aes(x = Var1, y = Freq, group = Var2)) +
       facet_wrap(~ Var2, nrow = 1) +
       geom_bar(stat = "identity", fill = "darkgray") + 
       theme(axis.text.x = element_text(angle = 90, hjust = 1))

