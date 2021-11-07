source("R/functions-cryptocompare.R")


# Query Data --------------------------------------------------------------

api_key <- readLines(sprintf("%s/.cryptocompare-apikey", Sys.getenv("HOME")))

btc_daily_historical <- fetchHistoricalDailyPrice(crypto_sym = "BTC"
                                       , curr_sym = "USD"
                                       , api_key=api_key)

# unique by date? yes
nrow(btc_daily_historical) == length(unique(btc_daily_historical$date))

btc_daily_train <- btc_daily_historical[1:floor((nrow(btc_daily_historical) *.9)), ]
btc_daily_test <- btc_daily_historical[(floor((nrow(btc_daily_historical) *.9)) + 1):
                                         nrow(btc_daily_historical), ]
# Split corectly?
(nrow(btc_daily_test) + nrow(btc_daily_train)) == nrow(btc_daily_historical)


# Save data ---------------------------------------------------------------

saveRDS(btc_daily_historical, "data/btc_daily_historical.rds")
saveRDS(btc_daily_train, "data/btc_daily_train.rds")
saveRDS(btc_daily_test, "data/btc_daily_test.rds")





