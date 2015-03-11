#Cargando recursos para el ejercicio

#conversión Rmd a md para visualización en github
#library(knitr)
#knit2html("Ejercicio1.Rmd")

source("0-load.r")
source("1-prepare.r")
source("metadata.r")

library(ggplot2)
library(gridExtra)
install.packages("gridExtra")

german.data  <-  load()

colnames(german.data) <- german.colnames

german.data$good.loan <- as.factor(
    ifelse(
        german.data$good.loan == 1, 
        'GoodLoan', 
        'BadLoan'
    )
)

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



german.data  <-  german.decode(german.data,german.codes)


# Graficar relación entre credit.history y good.loan

# visualización de credit.history
credit.history.df  <- german.data %>%
    group_by(credit.history) %>%
    summarise(count = n()) %>%
    arrange(desc(count))

g1  <- ggplot(credit.history.df, aes(x= reorder(credit.history,count), y=count)) + 
    geom_bar(stat="identity", fill="steelblue") + 
    coord_flip() + 
    theme(axis.text.y=element_text(size=rel(0.9)))

# visualizando good.loan

good.loan.df  <-  german.data %>%
    count(good.loan)

g2  <- ggplot(good.loan.df, aes(x= reorder(good.loan,n), y=n)) + 
    geom_bar(stat="identity", fill="steelblue")

# Visualización combinando las 2 variables

credit.good.loan  <- german.data %>%
    group_by(credit.history,good.loan) %>%
    summarise(count = n())

g3 <- ggplot(credit.good.loan, aes(x= reorder(credit.history,count), y=count, fill = good.loan)) + 
    geom_bar(stat="identity") + 
    coord_flip() + 
    theme(axis.text.y=element_text(size=rel(0.9)))

g4 <- ggplot(credit.good.loan, aes(x = reorder(credit.history,-count), y = count)) + 
    geom_bar(stat = "identity", fill = "steelblue") +
    facet_wrap(~ good.loan) +
    xlab("Historial de Crédito") + ylab("Numero de créditos") + 
    theme(axis.text.x = element_text(angle = 90,size=14))

g5 <- ggplot(credit.good.loan, aes(x = good.loan, y = count, color =credit.history, group=credit.history)) +
    geom_line()




