
ggplot(german.data,aes(x=credit.history, fill=good.loan))+geom_histogram(position="dodge")+theme(axis.text.x = element_text(angle = 35, hjust = 1))

for(i in 1:ncol(german.data)){
  print (graf_expl(german.data,names(german.data[i])))
}

for(i in 1:(ncol(german.data)-1)){
  for (e in (i+1):ncol(german.data)){
    print (graf_expl2(german.data,names(german.data[i]),names(german.data[e])))
  }
}

