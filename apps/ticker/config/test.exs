use Mix.Config

config :ticker,
  processor: Ticker.Quote.Processor.Static,
  security_symbols: ["TSLA", "GOOG"],
  security_url: "https://api.iextrading.com/1.0/tops?symbols=",
  crypto_symbols: ["BTC"],
  crypto_url: "https://www.alphavantage.co/query?function=DIGITAL_CURRENCY_INTRADAY&market=EUR&apikey=BMJUV89AV3WCXFWU&symbol=BTC",
  