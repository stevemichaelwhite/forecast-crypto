# Get all values of C20 since it began
# library(crypto)

library(tidyverse)
library(magrittr)
library(tsibble)
library(feasts)
library(fable)
library(plotly)


# Old Data ----------------------------------------------------------------

# Data from https://www.cryptodatadownload.com/data/
btc_daily_old <- read_csv("data/Bittrex_BTCUSD_d.csv",skip = 1)
names(btc_daily_old) %<>% tolower()
btc_daily_old <- as_tsibble(btc_daily_old, key=symbol, index=date)
count_gaps(btc_daily_old)
scan_gaps(btc_daily_old)
btc_daily_old <- tsibble::fill_gaps(btc_daily_old)




# New Data --------------------------------------------------------------
# https://finance.yahoo.com/quote/BTC-USD/history/?guccounter=1&guce_referrer=aHR0cHM6Ly93d3cuZ29vZ2xlLmNvbS8&guce_referrer_sig=AQAAAMS17gOV2m6pptYDW8mI8vqiBNQwYXlvXwp67sPOLfecqzL8vkaE_70omdXZHshYymBjhRqjUqUfjjC4HiYeGCkPVi1lWvykvM243EgZzMe_JAfZzefhXB8Cdp0tEX_16Wu3tGMH7yREKVRuZ5t8PIF9xGHy_SxZi98pPMq1oyAB

# close price adjusted for splits
# close price adjusted for splits and dividend and/or capital gains distributions


btc_daily <- read_csv("data/BTC-USD.csv", skip=0, na="null")
names(btc_daily) %<>% tolower()
btc_daily %<>% rename(adj_close=`adj close`)
btc_daily <- as_tsibble(btc_daily, key=NULL, index=date)

# No gaps
count_gaps(btc_daily)
scan_gaps(btc_daily)
# btc_daily <- tsibble::fill_gaps(btc_daily)



# Convert daily to monthly by trimming out all other days in month
# Skip for now


# Save Results ------------------------------------------------------------

saveRDS(btc_daily, "data/btc_daily.rds")
saveRDS(btc_daily_old, "data/btc_daily_old.rds")
