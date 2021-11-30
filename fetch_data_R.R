require(TTR)
require(quantmod)
library(dplyr)
library(purrr)
library(tidyr)
library(psych)
check_if_normal_month <- function(date_string)
{
  if ((lubridate::ceiling_date(as.Date(date_string), unit = "month")-1 -as.Date(date_string)) %>% as.numeric()<=4 )
  {
    return ((lubridate::ceiling_date(as.Date(date_string), unit = "month")-1) %>% format( "%Y-%m-%d"))
  }
  else
  {
    return ("-1")
  }
}
get_data_for_a_stock <- function(stock_name)
{
  df=stock_name %>% getSymbols(auto.assign=FALSE) %>% monthlyReturn
  df=df[df %>% apply(1,function(row) all(row!=0)),]  %>% data.frame
  colnames(df) <- c("monthly_return")
  df <- cbind(stock_name=rep(stock_name,length(df)),raw_date = rownames(df), df)
  rownames(df) <- 1:nrow(df)
  df$date=map(df$raw_date,check_if_normal_month)
  df=df %>% filter(!date=="-1") %>% select(-raw_date)
  return (df%>% apply(2,as.character))
}
setwd("C:\\Users\\technoplanet\\Desktop\\LSE Projects\\ST443\\Group Project\\stock_monthly_data")
SYMs <- TTR::stockSymbols()
selected = SYMs[,c("Symbol", "Sector", "Industry")]
#selected=selected[1:5,]
for(i in 6465:nrow(selected)){
  ticker = selected$Symbol[i]
  print(ticker)
  data=tryCatch(get_data_for_a_stock(ticker),error=function(c) "error")
  if (!data=="error")
  {
    try(write.csv(data,file=paste(ticker,".csv",sep = ""),row.names = FALSE))
  }
}


