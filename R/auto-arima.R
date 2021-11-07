btc_daily_ts_train <- readRDS("data/btc_daily_ts_train.rds")

res <- btc_daily_ts_train  %>% model(ARIMA(close_guerro))
report(res)

btc_fit <- btc_daily_ts_train  %>% model(
      stepwise = ARIMA(close_guerro),
      search = ARIMA(close_guerro, stepwise=FALSE))

btc_fit %>% pivot_longer(names_to = "Model name",
                         values_to = "Orders")

glance(btc_fit)

btc_fit %>%
  select(search) %>%
  gg_tsresiduals()

glance(btc_fit)

btc_fit %>%
  select(stepwise) %>%
  gg_tsresiduals()

augment(btc_fit) %>%
  filter(.model=='search') %>%
  features(.innov, ljung_box, lag = 10, dof = 3)

p <- btc_fit %>%
  forecast(h=5) %>%
  filter(.model=='search')  %>%
  autoplot(tail(btc_daily_ts_train,200))

ggplotly(p)
