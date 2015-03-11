library(dplyr)
library(ggplot2)
source('german/utils.r')

german.data <-load()
german.data <- as.data.frame(sapply(german.data, FUN=german.decode))
german.data <- arreglacols(german.data)


################
df <- german.data[ , c("credit.history", "good.loan")] %>%
    group_by(credit.history, good.loan) %>%
    summarise(cuenta = n())
df <- transform(df, credit.history=reorder(credit.history, cuenta))
ggplot(df, aes(x=credit.history, y=cuenta)) +
    geom_bar(stat='identity') +
    coord_flip() +
    facet_wrap( ~good.loan)+
    theme(axis.text.y=element_text(size=rel(0.8)))

ggplot(df, aes(x=credit.history, y=cuenta, fill=good.loan)) +
    geom_bar(stat='identity') +
    coord_flip() +
    theme(axis.text.y=element_text(size=rel(0.8)))

ggplot(df, aes(x=credit.history, y=cuenta, fill=good.loan)) +
    geom_bar(stat='identity', position="dodge") +
    coord_flip() +
    theme(axis.text.y=element_text(size=rel(0.8)))

summary(german.data)