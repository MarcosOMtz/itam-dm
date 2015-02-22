Para leer los datos.

    #library(knitr)
    rm(list=ls())
    gc()

    ##          used (Mb) gc trigger (Mb) max used (Mb)
    ## Ncells 245886 13.2     407500 21.8   350000 18.7
    ## Vcells 446940  3.5     905753  7.0   870784  6.7

    source(file = '0_load_data.r')

    ## 
    ## Attaching package: 'dplyr'
    ## 
    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag
    ## 
    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

    ls()

    ## [1] "decode_data" "german.data" "load_data"

Para limpiar datos.

    source(file = '1_prepare_data.R')

Veamos los datos:

    #kable( head(german.data),  format = 'markdown')
    head(german.data)

    ##   Status of existing checking account Duration in month
    ## 1                          ... < 0 DM                 6
    ## 2                   0 <= ... < 200 DM                48
    ## 3                 no checking account                12
    ## 4                          ... < 0 DM                42
    ## 5                          ... < 0 DM                24
    ## 6                 no checking account                36
    ##                                               Credit history
    ## 1 critical account/other credits existing (not at this bank)
    ## 2                   existing credits paid back duly till now
    ## 3 critical account/other credits existing (not at this bank)
    ## 4                   existing credits paid back duly till now
    ## 5                            delay in paying off in the past
    ## 6                   existing credits paid back duly till now
    ##               Purpose Credit amount       Savings account/bonds
    ## 1    radio/television          1169 unknown/ no savings account
    ## 2    radio/television          5951                ... < 100 DM
    ## 3           education          2096                ... < 100 DM
    ## 4 furniture/equipment          7882                ... < 100 DM
    ## 5           car (new)          4870                ... < 100 DM
    ## 6           education          9055 unknown/ no savings account
    ##   Present employment since
    ## 1            .. >= 7 years
    ## 2       1 <= ... < 4 years
    ## 3       4 <= ... < 7 years
    ## 4       4 <= ... < 7 years
    ## 5       1 <= ... < 4 years
    ## 6       1 <= ... < 4 years
    ##   Installment rate in percentage of disposable income
    ## 1                                                   4
    ## 2                                                   2
    ## 3                                                   2
    ## 4                                                   2
    ## 5                                                   3
    ## 6                                                   2
    ##               Personal status and sex Other debtors / guarantors
    ## 1                       male : single                       none
    ## 2 female : divorced/separated/married                       none
    ## 3                       male : single                       none
    ## 4                       male : single                  guarantor
    ## 5                       male : single                       none
    ## 6                       male : single                       none
    ##   Present residence since
    ## 1                       4
    ## 2                       2
    ## 3                       3
    ## 4                       4
    ## 5                       4
    ## 6                       4
    ##                                                          Property
    ## 1                                                     real estate
    ## 2                                                     real estate
    ## 3                                                     real estate
    ## 4 if not A121 : building society savings agreement/life insurance
    ## 5                                           unknown / no property
    ## 6                                           unknown / no property
    ##   Age in years Other installment plans  Housing
    ## 1           67                    none      own
    ## 2           22                    none      own
    ## 3           49                    none      own
    ## 4           45                    none for free
    ## 5           53                    none for free
    ## 6           35                    none for free
    ##   Number of existing credits at this bank                         Job
    ## 1                                       2 skilled employee / official
    ## 2                                       1 skilled employee / official
    ## 3                                       1        unskilled - resident
    ## 4                                       1 skilled employee / official
    ## 5                                       2 skilled employee / official
    ## 6                                       1        unskilled - resident
    ##   Number of people being liable to provide maintenance for
    ## 1                                                        1
    ## 2                                                        1
    ## 3                                                        2
    ## 4                                                        2
    ## 5                                                        2
    ## 6                                                        2
    ##                                  Telephone foreign worker Good.Loan
    ## 1 yes, registered under the customers name            yes  GoodLoan
    ## 2                                     none            yes   BadLoan
    ## 3                                     none            yes  GoodLoan
    ## 4                                     none            yes  GoodLoan
    ## 5                                     none            yes   BadLoan
    ## 6 yes, registered under the customers name            yes  GoodLoan

-   ¿Hay algo raro con los datos de préstamo?

Parece que hay muchos clientes con buenos prestamos.

    nrow(german.data)

    ## [1] 1000

    ncol(german.data)

    ## [1] 21

    summary(german.data)

    ##             Status of existing checking account.V1           
    ##  ... < 0 DM                                            :274  
    ##  ... >= 200 DM / salary assignments for at least 1 year: 63  
    ##  0 <= ... < 200 DM                                     :269  
    ##  no checking account                                   :394  
    ##                                                              
    ##                                                              
    ##                                                              
    ##  Duration in month
    ##  Min.   : 4.0     
    ##  1st Qu.:12.0     
    ##  Median :18.0     
    ##  Mean   :20.9     
    ##  3rd Qu.:24.0     
    ##  Max.   :72.0     
    ##                   
    ##                         Credit history.V1                        
    ##  all credits at this bank paid back duly                   : 49  
    ##  critical account/other credits existing (not at this bank):293  
    ##  delay in paying off in the past                           : 88  
    ##  existing credits paid back duly till now                  :530  
    ##  no credits taken/all credits paid back duly               : 40  
    ##                                                                  
    ##                                                                  
    ##         Purpose.V1         Credit amount  
    ##  radio/television   :280   Min.   :  250  
    ##  car (new)          :234   1st Qu.: 1366  
    ##  furniture/equipment:181   Median : 2320  
    ##  car (used)         :103   Mean   : 3271  
    ##  business           : 97   3rd Qu.: 3972  
    ##  education          : 50   Max.   :18424  
    ##  (Other)            : 55                  
    ##      Savings account/bonds.V1      Present employment since.V1
    ##  .. >= 1000 DM              : 48   .. >= 7 years     :253     
    ##  ... < 100 DM               :603   ... < 1 year      :172     
    ##  100 <= ... < 500 DM        :103   1 <= ... < 4 years:339     
    ##  500 <= ... < 1000 DM       : 63   4 <= ... < 7 years:174     
    ##  unknown/ no savings account:183   unemployed        : 62     
    ##                                                               
    ##                                                               
    ##  Installment rate in percentage of disposable income
    ##  Min.   :1.00                                       
    ##  1st Qu.:2.00                                       
    ##  Median :3.00                                       
    ##  Mean   :2.97                                       
    ##  3rd Qu.:4.00                                       
    ##  Max.   :4.00                                       
    ##                                                     
    ##         Personal status and sex.V1         Other debtors / guarantors.V1
    ##  female : divorced/separated/married:310   co-applicant: 41             
    ##  male : divorced/separated          : 50   guarantor   : 52             
    ##  male : married/widowed             : 92   none        :907             
    ##  male : single                      :548                                
    ##                                                                         
    ##                                                                         
    ##                                                                         
    ##  Present residence since
    ##  Min.   :1.00           
    ##  1st Qu.:2.00           
    ##  Median :3.00           
    ##  Mean   :2.85           
    ##  3rd Qu.:4.00           
    ##  Max.   :4.00           
    ##                         
    ##                               Property.V1                             
    ##  if not A121 : building society savings agreement/life insurance:232  
    ##  if not A121/A122 : car or other, not in attribute 6            :332  
    ##  real estate                                                    :282  
    ##  unknown / no property                                          :154  
    ##                                                                       
    ##                                                                       
    ##                                                                       
    ##   Age in years  Other installment plans.V1   Housing.V1  
    ##  Min.   :19.0   bank  :139                 for free:108  
    ##  1st Qu.:27.0   none  :814                 own     :713  
    ##  Median :33.0   stores: 47                 rent    :179  
    ##  Mean   :35.5                                            
    ##  3rd Qu.:42.0                                            
    ##  Max.   :75.0                                            
    ##                                                          
    ##  Number of existing credits at this bank
    ##  Min.   :1.00                           
    ##  1st Qu.:1.00                           
    ##  Median :1.00                           
    ##  Mean   :1.41                           
    ##  3rd Qu.:2.00                           
    ##  Max.   :4.00                           
    ##                                         
    ##                                Job.V1                              
    ##  management/ self-employed/highly qualified employee/ officer:148  
    ##  skilled employee / official                                 :630  
    ##  unemployed/ unskilled - non-resident                        : 22  
    ##  unskilled - resident                                        :200  
    ##                                                                    
    ##                                                                    
    ##                                                                    
    ##  Number of people being liable to provide maintenance for
    ##  Min.   :1.00                                            
    ##  1st Qu.:1.00                                            
    ##  Median :1.00                                            
    ##  Mean   :1.16                                            
    ##  3rd Qu.:1.00                                            
    ##  Max.   :2.00                                            
    ##                                                          
    ##                   Telephone.V1                  foreign worker.V1
    ##  none                                    :596   no : 37          
    ##  yes, registered under the customers name:404   yes:963          
    ##                                                                  
    ##                                                                  
    ##                                                                  
    ##                                                                  
    ##                                                                  
    ##     Good.Loan  
    ##  BadLoan :300  
    ##  GoodLoan:700  
    ##                
    ##                
    ##                
    ##                
    ## 

    str(german.data)

    ## 'data.frame':    1000 obs. of  21 variables:
    ##  $ Status of existing checking account                     : chr [1:1000, 1] "... < 0 DM" "0 <= ... < 200 DM" "no checking account" "... < 0 DM" ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr  "init" "" "" "" ...
    ##   .. ..$ : NULL
    ##  $ Duration in month                                       : int  6 48 12 42 24 36 24 36 12 30 ...
    ##  $ Credit history                                          : chr [1:1000, 1] "critical account/other credits existing (not at this bank)" "existing credits paid back duly till now" "critical account/other credits existing (not at this bank)" "existing credits paid back duly till now" ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr  "init" "" "" "" ...
    ##   .. ..$ : NULL
    ##  $ Purpose                                                 : chr [1:1000, 1] "radio/television" "radio/television" "education" "furniture/equipment" ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr  "init" "" "" "" ...
    ##   .. ..$ : NULL
    ##  $ Credit amount                                           : int  1169 5951 2096 7882 4870 9055 2835 6948 3059 5234 ...
    ##  $ Savings account/bonds                                   : chr [1:1000, 1] "unknown/ no savings account" "... < 100 DM" "... < 100 DM" "... < 100 DM" ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr  "init" "" "" "" ...
    ##   .. ..$ : NULL
    ##  $ Present employment since                                : chr [1:1000, 1] ".. >= 7 years" "1 <= ... < 4 years" "4 <= ... < 7 years" "4 <= ... < 7 years" ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr  "init" "" "" "" ...
    ##   .. ..$ : NULL
    ##  $ Installment rate in percentage of disposable income     : int  4 2 2 2 3 2 3 2 2 4 ...
    ##  $ Personal status and sex                                 : chr [1:1000, 1] "male : single" "female : divorced/separated/married" "male : single" "male : single" ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr  "init" "" "" "" ...
    ##   .. ..$ : NULL
    ##  $ Other debtors / guarantors                              : chr [1:1000, 1] "none" "none" "none" "guarantor" ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr  "init" "" "" "" ...
    ##   .. ..$ : NULL
    ##  $ Present residence since                                 : int  4 2 3 4 4 4 4 2 4 2 ...
    ##  $ Property                                                : chr [1:1000, 1] "real estate" "real estate" "real estate" "if not A121 : building society savings agreement/life insurance" ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr  "init" "" "" "" ...
    ##   .. ..$ : NULL
    ##  $ Age in years                                            : int  67 22 49 45 53 35 53 35 61 28 ...
    ##  $ Other installment plans                                 : chr [1:1000, 1] "none" "none" "none" "none" ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr  "init" "" "" "" ...
    ##   .. ..$ : NULL
    ##  $ Housing                                                 : chr [1:1000, 1] "own" "own" "own" "for free" ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr  "init" "" "" "" ...
    ##   .. ..$ : NULL
    ##  $ Number of existing credits at this bank                 : int  2 1 1 1 2 1 1 1 1 2 ...
    ##  $ Job                                                     : chr [1:1000, 1] "skilled employee / official" "skilled employee / official" "unskilled - resident" "skilled employee / official" ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr  "init" "" "" "" ...
    ##   .. ..$ : NULL
    ##  $ Number of people being liable to provide maintenance for: int  1 1 2 2 2 2 1 1 1 1 ...
    ##  $ Telephone                                               : chr [1:1000, 1] "yes, registered under the customers name" "none" "none" "none" ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr  "init" "" "" "" ...
    ##   .. ..$ : NULL
    ##  $ foreign worker                                          : chr [1:1000, 1] "yes" "yes" "yes" "yes" ...
    ##   ..- attr(*, "dimnames")=List of 2
    ##   .. ..$ : chr  "init" "" "" "" ...
    ##   .. ..$ : NULL
    ##  $ Good.Loan                                               : Factor w/ 2 levels "BadLoan","GoodLoan": 2 1 2 2 1 2 2 2 2 1 ...

    summary(german.data$Good.Loan)

    ##  BadLoan GoodLoan 
    ##      300      700

Esto debería ser congruente con el riesgo crediticio.

    table(german.data[,'Credit history'],german.data[,'Good.Loan'] )

    ##                                                             
    ##                                                              BadLoan
    ##   all credits at this bank paid back duly                         28
    ##   critical account/other credits existing (not at this bank)      50
    ##   delay in paying off in the past                                 28
    ##   existing credits paid back duly till now                       169
    ##   no credits taken/all credits paid back duly                     25
    ##                                                             
    ##                                                              GoodLoan
    ##   all credits at this bank paid back duly                          21
    ##   critical account/other credits existing (not at this bank)      243
    ##   delay in paying off in the past                                  60
    ##   existing credits paid back duly till now                        361
    ##   no credits taken/all credits paid back duly                      15

-   ¿Cuál crees que debería ser la distribución del resultado del
    préstamo `Good.Loan` respecto a `Credit history`?

-   Grafícalo y comenta tus resultados.

En la gráfica a continuación se ven las distribiciones por Good y Bad
Loan. Se puede ver que las distribuciones práctimante son iguales. Esto
no debería ser así, deberían de ser contrarias.

    names(german.data) <- tolower(gsub(names(german.data),pattern = ' ', replacement = '.'))

    library(ggplot2)
    df <- as.data.frame(prop.table(table(german.data[,'credit.history'],german.data[,'good.loan'] )))
    ggplot(df, aes(x=Var1, y=Freq)) +
      geom_bar(stat='identity') +
      facet_wrap( ~Var2)+
      coord_flip()

![plot of chunk
unnamed-chunk-6](./ejercicio_files/figure-markdown_strict/unnamed-chunk-6.png)
