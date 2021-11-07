# Procedure from https://otexts.com/fpp3/arima-r.html

library(tidyverse)
library(magrittr)
library(tsibble)
library(feasts)
library(fable)
library(plotly)
library(lubridate)
library(latex2exp)


btc_daily_ts_train <- readRDS("data/btc_daily_ts_train.rds")
plot_res <- list()


# 1. Plot the data and identify any unusual observations. -----

close_mean <- mean(btc_daily_ts_train$close_price)
p <- btc_daily_ts_train %>% autoplot(close_price) +
  labs(title="Daily Close Price",
       y="USD") + geom_hline(yintercept = close_mean)

plot_res[["btc_raw"]] <- ggplotly(p)


p <- btc_daily_ts_train %>% autoplot(close_price) +
  labs(title="Daily Close Price",
       y="USD") + facet_wrap(vars(year(date)), scales="free", ncol=1)
plot_res[["btc_raw_byyear"]] <- ggplotly(p, height=2000)





# 2. If necessary, transform the data (using a Box-Cox transformation) to stabilise the variance. -----

lambda <- btc_daily_ts_train  %>%
  features(close_price, features = guerrero) %>%
  pull(lambda_guerrero)

p <- btc_daily_ts_train %>%
  autoplot(box_cox(close_price, lambda)) 

p_plotly <- ggplotly(p) %>% 
  layout(title = plotly::TeX(paste0(
    "\\text{Transformed close price } \\lambda = ",
    round(lambda,2)))) %>% config(mathjax = 'cdn')

plot_res[["btc_guerrero"]] <- p_plotly

p <- btc_daily_ts_train %>%
  autoplot(log(close_price)) 

p_plotly <- ggplotly(p) %>% 
  layout(title = "Natural log transformation") 

plot_res[["btc_log"]] <- p_plotly

btc_daily_ts_train <- btc_daily_ts_train %>% mutate(close_guerro = box_cox(close_price, lambda))


# 3. If the data are non-stationary, take first differences of the data until the data are stationary.
btc_daily_ts_train <- btc_daily_ts_train %>% mutate(close_guer_diff = difference(close_guerro))

# Dicky fuller test here
btc_daily_ts_train %>% features(close_guerro, unitroot_ndiffs)
btc_daily_ts_train %>% features(close_guerro, unitroot_nsdiffs)

btc_daily_ts_train %>% features(close_guerro, unitroot_kpss)
btc_daily_ts_train %>% features(close_guer_diff, unitroot_kpss)



# 4. Examine the ACF/PACF: Is an ARIMA(p,d,0) or ARIMA(0,d,q) model appropriate?

btc_daily_ts_train %>%  gg_tsdisplay(close_guer_diff, plot_type='partial')
btc_acf <- btc_daily_ts_train %>% ACF(close_guer_diff) 
sd(btc_daily_ts_train$close_guer_diff, na.rm = TRUE)

plot_res[["btc_acf"]] <- btc_daily_ts_train %>% ACF(close_guer_diff) %>% autoplot() 
plot_res[["btc_pacf"]] <- btc_daily_ts_train %>% PACF(close_guer_diff) %>% autoplot() 
btc_daily_ts_train  %>% gg_lag(close_guer_diff, geom="point")


# Save results ------------------------------------------------------------

saveRDS(plot_res,"data/plot_res.rds")
saveRDS(btc_daily_ts_train,"data/btc_daily_ts_train.rds")
