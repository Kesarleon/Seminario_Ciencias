
# coding: utf-8

# In[36]:

import urllib2
from bs4 import BeautifulSoup as bs
import csv

###### Create the function
def getYahoo_records(name, numRecords):
    
    records = dict( dates=[], prices=[])
    
    url = "https://finance.yahoo.com/quote/" + name + "/history/"
    HTMLtable = bs(  urllib2.urlopen(url).read(), "lxml" ).findAll('table')[0].tbody.findAll('tr')
    
    for row in HTMLtable:
        if len(records) < numRecords:
            dataPerColumn = row.findAll('td')
            #if dataPerColumn[1].span.text  != 'Dividend': 
            records['dates'].append( dataPerColumn[0].span.text )
            records['prices'].append( float(dataPerColumn[4].span.text.replace(',','')) )
    
    return records


###### Call the function and get output in the sample_stock variable (structure = dictionary)
sampleStock = getYahoo_records('amzn', 10)


###### Create a csv file with results of this dictionary
with open('sampleStock.csv','wb') as f:
    w = csv.writer(f)
    #### Header
    w.writerow( ('Dates','Prices') )
    #### Rows
    for i in range(10):
        w.writerow( (sampleStock['dates'][i],sampleStock['prices'][i]) )
      





