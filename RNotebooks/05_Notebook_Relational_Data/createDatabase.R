library(dplyr)

dataset<- read.csv('/Users/alimon/Documents/dataset/Yahoo/dataset.csv')
dataset<- subset(dataset, Industry!='') 
dataset$dummy<-1
dataset<- aggregate(dummy ~ Sector, dataset, FUN=sum)
aggr


#Basic Materials, Conglomerates, Consumer Goods, Financial, Healthcare
#Industrial Goods, Services, Technology, Utilities.


dataset$key<- paste0(dataset$Address, dataset$Country)
dataset<- filter(dataset, key!='')

Mode <- function(x) {
  ux <- unique(x)
  ux[which.max(tabulate(match(x, ux)))]
}

#### 1
Industry<- aggregate(Industry ~ key, dataset, Mode)
Sector<- aggregate(Sector ~ key, dataset, Mode)

dataset_entity_industry<- as.data.frame(unique(dataset$key))
colnames(dataset_entity_industry)[1]<-"constructed_key" 
dataset_entity_industry$key<- paste0("comp", "_",seq(1,length(unique(dataset$key))))
#dataset_entity_industry<- merge(dataset_entity_industry, Name, by.x='constructed_key', by.y = "key")
dataset_entity_industry<- merge(dataset_entity_industry, Sector, by.x='constructed_key', by.y = "key")
dataset_entity_industry<- merge(dataset_entity_industry, Industry, by.x='constructed_key', by.y = "key")
dataset_entity_industry$constructed_key<-NULL
colnames(dataset_entity_industry)[1]<- 'comp_id'
write.csv(dataset_entity_industry, '/Users/alimon/Documents/dataset/Yahoo/dataset_comp_industry.csv', row.names = FALSE)

#### 2
Name<- aggregate(Name ~ key, dataset, Mode)
Address<- aggregate(Address ~ key, dataset, Mode)
City<- aggregate(City ~ key, dataset, Mode)
Country<- aggregate(Country ~ key, dataset, Mode)
State<- aggregate(State ~ key, dataset, Mode)
zip<- aggregate(zip ~ key, dataset, Mode)

dataset_entity_profile<- as.data.frame(unique(dataset$key))
colnames(dataset_entity_profile)[1]<-"constructed_key" 
dataset_entity_profile$key<- paste0("comp", "_",seq(1,length(unique(dataset$key))))
dataset_entity_profile<- merge(dataset_entity_profile,Name, by.x='constructed_key', by.y = "key", all.x = TRUE)
dataset_entity_profile<- merge(dataset_entity_profile, Address, by.x='constructed_key', by.y = "key", all.x = TRUE)
dataset_entity_profile<- merge(dataset_entity_profile, City, by.x='constructed_key', by.y = "key", all.x = TRUE)
dataset_entity_profile<- merge(dataset_entity_profile, Country, by.x='constructed_key', by.y = "key", all.x = TRUE)
dataset_entity_profile<- merge(dataset_entity_profile, State, by.x='constructed_key', by.y = "key", all.x = TRUE)
dataset_entity_profile<- merge(dataset_entity_profile, zip, by.x='constructed_key', by.y = "key", all.x = TRUE)
colnames(dataset_entity_profile)[2]<- 'comp_id'
dataset_entity_profile$constructed_key<-NULL
write.csv(dataset_entity_profile, '/Users/alimon/Documents/dataset/Yahoo/dataset_comp_profile.csv', row.names = FALSE)

dataset_sec<- dataset %>% distinct(Ticker, Exchange,financialCurrency,currentPrice, sharesOutstanding) %>% select(Ticker, Exchange,financialCurrency,currentPrice, sharesOutstanding)
dataset_sec$sec_id<- paste0("sec", "_",seq(1,length(unique(dataset_sec$Ticker))))
write.csv(dataset_sec, '/Users/alimon/Documents/dataset/Yahoo/dataset_sec.csv', row.names = FALSE)

#### Run part of entity profile until before the constructed key
dataset_entity_profile<- select(dataset_entity_profile, constructed_key, comp_id)
dataset_entity_profile$constructed_key<- as.character(dataset_entity_profile$constructed_key)
dataset_sec<- select(dataset_sec, Ticker,sec_id)
dataset_sec_comp<- merge(dataset, dataset_sec, by='Ticker')
dataset_sec_comp$key<- as.character(dataset_sec_comp$key)
dataset_sec_comp<- merge(dataset_sec_comp, dataset_entity_profile, by.x='key', by.y = 'constructed_key', all.x = TRUE)
dataset_sec_comp<- select(dataset_sec_comp, sec_id, comp_id)

write.csv(dataset_sec_comp, '/Users/alimon/Documents/dataset/Yahoo/dataset_sec_comp.csv', row.names = FALSE)

a<- Quandl("EOD/HD", api_key="LgiHY6VXyxDDMHs4Er77")



