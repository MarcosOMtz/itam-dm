load  <-  function()
{
    if (file.exists('german.rds')){
        german.data <- readRDS('german.rds')
        german.data
    }
    else{
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

