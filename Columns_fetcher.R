library(tidyr)
library(purrr)
library(dplyr)
library(stringr)
setwd("C:\\Users\\technoplanet\\Desktop\\LSE Projects\\ST443\\Group Project\\Factor_data")
files=dir()
a=read.csv(files[1])
data=a[c('Date','fdate')]
criteria=c('AR_1','AR_5')
name_now=c("")
for (file in files)
{
  temp=read.csv(file)
  factor_name=temp[c(3)] %>% names %>% str_replace_all("AR_1", "")
  if (!(factor_name %in% name_now))
  {
    name_now=append(name_now,factor_name)
    criteria_new=criteria %>% map(function (x) paste(factor_name,x,sep="")) %>% unlist %>% append(c('Date','fdate'),after=0)
    #data_new=temp[criteria_new] %>% mutate({{factor_name}}:={{criteria_new[1]}}-{{criteria_new[2]}})
    # wanting to get AR_1-AR_5 to get something like High minus Low
    data=merge(data,data_new[,!(names(mydata) %in% criteria_new)],by=c('Date','fdate'))
  }

}
data
setwd("C:\\Users\\technoplanet\\Desktop\\LSE Projects\\ST443\\Group Project")
write.csv(data,"final.csv")

