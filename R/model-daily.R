# Procedure from https://otexts.com/fpp3/arima-r.html


# 1. Plot the data and identify any unusual observations.

p <- btc_ts %>% autoplot(close) +
  labs(title="Close Price",
       y="USD")
ggplotly()


# 2. If necessary, transform the data (using a Box-Cox transformation) to stabilise the variance.


# 3. If the data are non-stationary, take first differences of the data until the data are stationary.
# 4. Examine the ACF/PACF: Is an ARIMA(p,d,0) or ARIMA(0,d,q) model appropriate?
# 5. Try your chosen model(s), and use the AICc to search for a better model.
# 6. Check the residuals from your chosen model by plotting the ACF of the residuals, and doing a portmanteau test of the residuals. If they do not look like white noise, try a modified model.
# 7. Once the residuals look like white noise, calculate forecasts.