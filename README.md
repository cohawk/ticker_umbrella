# TickerUmbrella

Originally based off - Elixir OTP Stock Quotes App (IEX Group)
https://github.com/philcallister/ticker-elixir

## Installation

```
mix deps.get
cd ticker-react
npm install
```

## Running

Elixir / Phoenix Ticker Umbrella (API Backend)

```
mix phx.server
```


Webpack Development Node Server (React Frontend)

```
cd ticker-react
npm start
```

View in Web Browser
```
http://localhost:3000
```


## APIs

Ticker Data API (config.exs)

Currently Using:

  Stock

      iextrading_url: "https://api.iextrading.com/1.0/tops?symbols="

      https://iextrading.com/

  Crypto

      crypto_url: "https://min-api.cryptocompare.com/data/pricemultifull?tsyms=USD&fsyms="

      https://www.cryptocompare.com/


Possibly better Crypo API:

  https://coinmarketcap.com/api/ (may require PAID usage soon)

