require(TTR)
require(quantmod)
library(dplyr)
library(purrr)
library(tidyr)
library(psych)
merge_regression <- function(y,x)
{
  data=merge(y,x,by="date"
}