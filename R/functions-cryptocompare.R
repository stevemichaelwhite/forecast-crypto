library(httr)
library(jsonlite)
library(magrittr)
library(dplyr)
library(stringr)



# functions ---------------------------------------------------------------

executeCall <- function(the_call, api_key){
  api_return <- sprintf("%s&api_key={%s}", the_call, api_key) %>% GET()
  return_json <- content(api_return,"text")
  fromJSON(return_json,flatten=TRUE)
}

fetchHistoricalDailyPrice <- function(crypto_sym = "BTC", curr_sym = "USD", api_key){
  the_call <- sprintf("https://min-api.cryptocompare.com/data/v2/histoday?fsym=%s&tsym=%s&allData=true"
                      , crypto_sym
                      , curr_sym)
  call_return <- executeCall(the_call, api_key)
  crypto_df <- as.data.frame(call_return$Data)
  names(crypto_df) <- names(crypto_df) %>% tolower() %>% 
    str_replace(pattern = "[.]", replacement = "_")
  
  crypto_df %<>% mutate(timefrom=as.POSIXct(timefrom, origin="1970-01-01")
                        , timeto=as.POSIXct(timeto, origin="1970-01-01")
                        , data.time=as.POSIXct(data.time, origin="1970-01-01")
                        , date = as.Date(data.time)
                        , .before = 1
  )
  
  call_return$Data <- NULL
  attr(crypto_df,"call_meta") <- call_return
  
  crypto_df
  
}
