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
transfer_percentage_to_number <- function(x)
{
  return (as.numeric(sub("%","",x))/100)
}
for (file in files)
{

  temp=read.csv(file)
  factor_name=temp[c(3)] %>% names %>% str_replace_all("AR_1", "")
  if (!(factor_name %in% name_now))
  {
    name_now=append(name_now,factor_name)
    criteria_new=criteria %>% map(function (x) paste(factor_name,x,sep="")) %>% unlist %>% append(c('Date','fdate'),after=0)
    data_new=temp[criteria_new]
    names(data_new)[c(3:4)]=c("AR_1","AR_5")
    data_new$AR_1=data_new$AR_1 %>% map(transfer_percentage_to_number) %>% unlist
    data_new$AR_5=data_new$AR_5 %>% map(transfer_percentage_to_number) %>% unlist
    #data_new=apply(data_new,2,as.character)
    data_new <- data_new %>% mutate(HML=AR_1-AR_5)
    data_new<-data_new[,(names(data_new) %in% c("Date","fdate","HML"))]
    
    names(data_new)[c(3)]=paste(factor_name,"HML",sep="")

    #data_new=temp[criteria_new] %>% mutate({{factor_name}}:={{criteria_new[1]}}-{{criteria_new[2]}})
    # wanting to get AR_1-AR_5 to get something like High minus Low
    data=merge(data,data_new,by=c('Date','fdate'))
  }

}
data
setwd("C:\\Users\\technoplanet\\Desktop\\LSE Projects\\ST443\\Group Project")
names(data)[1]="date"
data$date=map(data$date,function(x) format(as.Date(x),"%Y-%m-%d")) 
data=data[,!(names(data) %in% c("fdate"))]
data$date
data=apply(data,2,as.character)
FF_5_factor=read.csv("F-F_Research_Data_5_Factors_2x3.csv")
refactor_ff <- function(FF_5_factor)
{
  add_zero <- function(a)
  {
    if (a<10)
    {
      return (paste("0",as.character(a),sep = ""))
    }
    else
    {
      return (as.character(a))
    }
  }
  month_to_end_of_month <- function(a)
  {
    temp=a*100+3
    date_now=c(as.character(floor(temp/10000)),add_zero(floor((temp-floor(temp/10000)*10000)/100)),"03")
    date_chr=paste(date_now[1],date_now[2],date_now[3],sep="-")
    return ((lubridate::ceiling_date(as.Date(date_chr), unit = "month")-1) %>% format( "%Y-%m-%d"))
  }
  ((lubridate::ceiling_date(as.Date(date_chr), unit = "month")-1) %>% format( "%Y-%m-%d"))
  FF_5_factor$date=FF_5_factor$X %>% map(month_to_end_of_month)
  FF_5_factor$Mkt.RF=FF_5_factor$Mkt.RF %>% map(function(x) x/100)
  FF_5_factor$SMB=FF_5_factor$SMB %>% map(function(x) x/100)
  FF_5_factor$HML=FF_5_factor$HML %>% map(function(x) x/100)
  FF_5_factor$RMW=FF_5_factor$RMW %>% map(function(x) x/100)
  FF_5_factor$CMA=FF_5_factor$CMA %>% map(function(x) x/100)
  FF_5_factor$RF=FF_5_factor$RF %>% map(function(x) x/100)
  return (FF_5_factor[,(names(FF_5_factor) %in% c("Mkt.RF","SMB","HML","RMW","CMA","RF","date"))])
}
refactor_ff(FF_5_factor)
data=merge(data,refactor_ff(FF_5_factor),by="date")
data
month_to_end_of_month(197407)
write.csv(data,"final.csv")

as.numeric(sub("%","","-1.08%"))/100
