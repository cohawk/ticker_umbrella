defmodule Ticker.Quote do
  @moduledoc """
  Quote Struct

  https://min-api.cryptocompare.com/data/pricemultifull?tsyms=USD&fsyms=BTC

  TYPE: "5",
  MARKET: "CCCAGG",
  FROMSYMBOL: "BTC",
  TOSYMBOL: "USD",
  FLAGS: "1",
  PRICE: 18707.35,
  LASTUPDATE: 1513665808,
  LASTVOLUME: 0.00255,
  LASTVOLUMETO: 47.882115,
  LASTTRADEID: "1513665808.2202",
  VOLUMEDAY: 26147.555846386662,
  VOLUMEDAYTO: 492425684.76571,
  VOLUME24HOUR: 106302.35511532817,
  VOLUME24HOURTO: 1993433052.7955282,
  OPENDAY: 18971.19,
  HIGHDAY: 19021.97,
  LOWDAY: 18673.29,
  OPEN24HOUR: 18964.85,
  HIGH24HOUR: 19244.65,
  LOW24HOUR: 18210.92,
  LASTMARKET: "Kraken",
  CHANGE24HOUR: -257.5,
  CHANGEPCT24HOUR: -1.3577750417219225,
  CHANGEDAY: -263.84000000000015,
  CHANGEPCTDAY: -1.390740380545449,
  SUPPLY: 16750887,
  MKTCAP: 313364705919.44995,
  TOTALVOLUME24H: 287924.1895424658,
  TOTALVOLUME24HTO: 5391096277.066041

  https://api.iextrading.com/1.0/tops?symbols=AAPL
  * symbol:        the stock ticker.
  * marketPercent: IEX's percentage of the market in the stock.
  * bidSize:       amount of shares on the bid on IEX.
  * bidPrice:      the best bid price on IEX.
  * askSize:       amount of shares on the ask on IEX.
  * askPrice:      the best ask price on IEX.
  * volume:        shares traded in the stock on IEX.
  * lastSalePrice: last sale price of the stock on IEX.
  * lastSaleSize:  last sale size of the stock on IEX.
  * lastSaleTime:  last sale time in epoch time of the stock on IEX.
  * lastUpdated:   the last update time of the data in milliseconds since midnight Jan 1, 1970 or -1. If the value is -1, IEX has not quoted the symbol in the trading day.
  * lastReqTime:   time of last request. This isn't returned from IEX but is used for interval framing
  """

  @derive [Poison.Encoder]
  defstruct [
    :symbol,
    :marketPercent,
    :bidSize,
    :bidPrice,
    :askSize,
    :askPrice,
    :volume,
    :lastSalePrice,
    :lastSaleSize,
    :lastSaleTime,
    :lastUpdated,
    :lastReqTime
  ]

  def is_a_quote?(%Ticker.Quote{}), do: true
  def is_a_quote?(_), do: false

  def as_type(ticker_quote, type \\ :string) do
    type_fn = case type do
      :string -> fn(value, sign, precision) -> as_string(value, sign, precision) end
      _       -> fn(value, _, _) -> as_float(value) end
    end

    %Ticker.Quote{
      symbol:         ticker_quote.symbol,
      marketPercent:  type_fn.(ticker_quote.marketPercent, false, 5),
      bidSize:        ticker_quote.bidSize,
      bidPrice:       type_fn.(ticker_quote.bidPrice, false, 3),
      askSize:        ticker_quote.askSize,
      askPrice:       type_fn.(ticker_quote.askPrice, false, 3),
      volume:         ticker_quote.volume,
      lastSalePrice:  type_fn.(ticker_quote.lastSalePrice, false, 3),
      lastSaleSize:   ticker_quote.lastSaleSize,
      lastSaleTime:   ticker_quote.lastSaleTime,
      lastUpdated:    ticker_quote.lastUpdated,
      lastReqTime:    ticker_quote.lastReqTime
    }

  end

  defp as_string(value, sign, precision) do
    pre = case sign do
      true when value > 0 -> "+"
      _ -> nil
    end
    ~s(#{pre}#{:erlang.float_to_binary(value, decimals: precision)})
  end

  defp as_float(value) do
    String.to_float(value)
  end

  # TODO - needs multiple API calls to pull Order Data: bidSize, bidPrice, askSize, askPrice
  # https://bitcoin.stackexchange.com/questions/28265/how-is-bid-and-ask-calculated-for-crypto-currencies
  def from_crypto(ticker_quote) do
    %Ticker.Quote{
      symbol:         Map.get(ticker_quote, "FROMSYMBOL"),
      marketPercent:  Map.get(ticker_quote, "LASTVOLUME"),
      bidSize:        Map.get(ticker_quote, "LASTVOLUMETO"),
      bidPrice:       Map.get(ticker_quote, "PRICE"),
      askSize:        Map.get(ticker_quote, "LASTVOLUMETO"),
      askPrice:       Map.get(ticker_quote, "PRICE"),
      volume:         Map.get(ticker_quote, "VOLUMEDAY"),
      lastSalePrice:  Map.get(ticker_quote, "PRICE"),
      lastSaleSize:   Map.get(ticker_quote, "LASTVOLUMETO"),
      lastSaleTime:   Map.get(ticker_quote, "LASTTRADEID"),
      lastUpdated:    Map.get(ticker_quote, "LASTUPDATE"),
      lastReqTime:    nil
    }
  end

end
