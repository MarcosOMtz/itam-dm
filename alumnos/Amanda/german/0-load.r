source('utils.r')

# Verificamos si la base ya exite en la carpeta de trabajo y la leemos, utilizando la función load

archivo <- "german.rds"
german.data <- load(archivo)

# Definimos el vector con los nombres de las variables

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

# Asignamos los nombres a las variables de la base

colnames(german.data) <- german.colnames

