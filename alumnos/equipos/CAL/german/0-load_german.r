# Cargamos la base de datos usando función load

ds <- load(ds.name, ds.path, ds.url)

# Guardamos la base original

ds.original <- ds

# Definimos el vector con los nombres de las variables

ds.colnames <- c('Status of existing checking account', 
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

# Asignamos los nombres a las variables de la base original que nos servirá para gráficar

colnames(ds) <- ds.colnames

# Definimos el vector con los nombres de las variables para la base que nos servirá para gráficar

ds.original.colnames <- c('Status', 
                          'Duration',
                          'CreditH',
                          'Purpose',
                          'CreditA',
                          'Savings',
                          'Present',
                          'Installment',
                          'Personal',
                          'Other',
                          'PresentR',
                          'Property',
                          'Age',
                          'OtherP',
                          'Housing',
                          'Number',
                          'Job',
                          'Number',
                          'Telephone',
                          'Foreign',
                          'Good.Loan'
)

# Asignamos los nombres a las variables de la base original

colnames(ds.original) <- ds.original.colnames