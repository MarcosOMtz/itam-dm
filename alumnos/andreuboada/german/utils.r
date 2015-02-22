library(stringr)
library(dplyr)
library(gsubfn)
library(ggplot2)
library(plyr)

# Funcion pra cargar el archivo German Data
load <- function(){
  if(!file.exists('german.rds')){ #si el archivo no existe
    german.url <- paste('http://archive.ics.uci.edu/ml',
                        '/machine-learning-databases/statlog',
                        '/german/german.data',
                        sep='') #url de los datos
    # leer los datos de la red
    german.data <- read.table(german.url, 
                              stringsAsFactors = FALSE, 
                              header = FALSE) # lectura de datos
    saveRDS(german.data,'german.rds')
    return(german.data)
  }else{ #si el archivo existe
    print('El archivo ya existe')
    german.data = readRDS('german.rds') # se lee el archivo
    return(german.data)
  }
}

#lectura de datos
german.data = load()
head(german.data)

# colnames
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

german.colnames <- german.colnames%>%str_replace_all(pattern=" ",replace=".")
colnames(german.data) <- german.colnames%>%str_replace_all(pattern="/.",replace="")

# Poner los nombres a las columnas
colnames(german.data) <- german.colnames
german.data$Good.Loan <- as.factor(
  ifelse(
    german.data$Good.Loan == 1, 
    'GoodLoan', 
    'BadLoan'
  )
)

# Codigos de variables categoricas
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


# Decodificar variables
column.types<-lapply(german.data,class)
n<-length(column.types)
for(i in 1:n){
  if(column.types[i]=="character"){
    columna<-german.data[,i]
    german.data[,i] = as.factor(laply(columna,function(entrada){
      gsubfn(paste(names(german.codes),collapse='|'), german.codes,entrada)
    })) 
  }
}

str(german.data)

ggplot(german.data,aes(x=Credit.history))+
  geom_bar()+  
  coord_flip() + 
  facet_wrap(~Good.Loan)

ggplot(german.data, aes(Credit.history, fill=Good.Loan)) + 
  geom_bar() +  
  coord_flip() 

credit.history.tbl <- table(german.data$'Credit.history')
credit.history.df <- as.data.frame(credit.history.tbl)
colnames(credit.history.df) <- c('credit.history', 'count')
summary(credit.history.df)

credit.history.df <- transform(credit.history.df, 
                               credit.history=reorder(credit.history, count))
summary(credit.history.df)

ggplot(credit.history.df) + 
  geom_bar(aes(x=credit.history, y=count), stat="identity", fill="gray") + 
  coord_flip() + 
  theme(axis.text.y=element_text(size=rel(0.8)))

summary(german.data)
