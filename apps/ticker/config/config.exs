# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# 3rd-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :ticker, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:ticker, :key)
#
# You can also configure a 3rd-party app:
#
#     config :logger, level: :info
#

config :ticker,
  frequency: 15_000,
  processor: Ticker.Quote.Processor.HTTP,
  historical: false,
  security_symbols: ["TSLA", "GOOG", "AAPL", "TWTR", "FB", "GLD"],
  iextrading_url: "https://api.iextrading.com/1.0/tops?symbols=",
  crypto_symbols: ["BTC"],
  crypto_url: "https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_INTRADAY&market=EUR&apikey=BMJUV89AV3WCXFWU&symbol=BTC",
  quote_notify: [notify_module: :none, notify_fn: :none]

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
import_config "#{Mix.env}.exs"