# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# General application configuration
config :ticker_phoenix,
  namespace: TickerPhoenix,
  ecto_repos: [TickerPhoenix.Repo]

# Configures the endpoint
config :ticker_phoenix, TickerPhoenix.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "pMG5yV5m+mG9Wb4YkRIQxeUtzcbgB45FkcVSlj7SecdGKg5qKVGLAlBCfvgyNCnC",
  render_errors: [view: TickerPhoenix.ErrorView, accepts: ~w(json)],
  pubsub: [name: TickerPhoenix.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :ticker_phoenix, :generators,
  context_app: false

# Configure Ticker
config :ticker,
  frequency: 15_000,
  processor: Ticker.Quote.Processor.HTTP,
  historical: false,
  security_symbols: ["TSLA", "GOOG", "AAPL", "FB", "GLD"],
  security_url: "https://api.iextrading.com/1.0/tops?symbols=",
  crypto_symbols: ["BTC", "ETH", "LTC", "XRP", "BCH"],
  crypto_url: "https://min-api.cryptocompare.com/data/pricemultifull?tsyms=USD&fsyms=",
  quote_notify: [notify_module: TickerPhoenix.Listener, notify_fn: :notify_quotes],
  frame_notify: [notify_module: TickerPhoenix.Listener, notify_fn: :notify_frame]


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
