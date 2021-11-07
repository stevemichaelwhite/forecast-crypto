library(tidyverse)
library(magrittr)
library(tsibble)
library(feasts)
library(fable)
library(plotly)

btc_daily_train <- readRDS("data/btc_daily_train.rds")
btc_daily_sub <- btc_daily_train %>% select(date, data_close) %>% 
  rename(close_price = data_close) #%>% mutate(log_close = log(close)) %>% 
  # pivot_longer(cols=c(close,log_close), names_to="transformation", values_to="price")
# convert to tsibble
btc_daily_ts_train <- as_tsibble(btc_daily_sub, key=NULL, index=date)

# No gaps
count_gaps(btc_daily_ts_train)
scan_gaps(btc_daily_ts_train)

saveRDS(btc_daily_ts_train, "data/btc_daily_ts_train.rds")


