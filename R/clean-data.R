# Get all values of C20 since it began
# library(crypto)
library(tidyverse)
library(magrittr)
library(tsibble)
library(fable)
library(plotly)


# Data from https://www.cryptodatadownload.com/data/
btc <- read_csv("data/Bittrex_BTCUSD_d.csv",skip = 1)
names(btc) %<>% tolower()
# btc %<>% select(date, close)
btc_ts <- as_tsibble(btc, key=symbol, index=date)

# Convert daily to monthly by trimming out all other days in month


