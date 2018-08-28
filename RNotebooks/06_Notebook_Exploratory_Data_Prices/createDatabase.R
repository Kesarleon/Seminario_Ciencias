library(dplyr)
library(quantmod)

dataset_tickers<- read.csv('/Users/alimon/Documents/Github/2018_UNAM_CienciaDeDatosCapitales/RNotebooks/05_Notebook_Relational_Data/dataset/dataset_sec.csv')
dataset_tickers<- subset(dataset_tickers, Exchange %in% c('NMS', 'NYQ'))
tickers<- as.character(unique(dataset_tickers$Ticker))

prices_out<-NULL
for (i in seq(1, length(tickers))){
  print(i)
  prices<-getSymbols(tickers[i] ,auto.assign=FALSE)
  colnames(prices)<- c('Open','High', 'Low', 'Close', 'Volume', 'Adjusted')
  prices<- as.data.frame(prices)
  prices$dates<- row.names(prices)
  prices$ticker<- tickers[i]
  row.names(prices)<- NULL
  prices_out<- rbind(prices_out, prices)
}


save(prices_out, file='/Users/alimon/Documents/dataset/quantmod/prices_nms-nyq.RData')

