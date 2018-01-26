defmodule Ticker.Frame.Test do
  use ExUnit.Case, async: true

  @symbol "TSLA"
  @open_quote1 %Ticker.Quote{
    symbol: @symbol,
    marketPercent: "0.01024",
    bidSize: 100,
    bidPrice: "201.90",
    askSize: 100,
    askPrice: "202.10",
    volume: 33621,
    lastSalePrice: "200.00",
    lastSaleSize: 25,
    lastSaleTime: 1_477_050_425_000,
    lastUpdated: 1_477_050_425_000,
    lastReqTime: 1_477_050_425_000
  }
  @high_quote1 %Ticker.Quote{
    symbol: @symbol,
    marketPercent: "0.01024",
    bidSize: 100,
    bidPrice: "201.90",
    askSize: 100,
    askPrice: "202.10",
    volume: 33621,
    lastSalePrice: "202.00",
    lastSaleSize: 25,
    lastSaleTime: 1_477_050_430_000,
    lastUpdated: 1_477_050_430_000,
    lastReqTime: 1_477_050_430_000
  }
  @skip_quote1 %Ticker.Quote{
    symbol: @symbol,
    marketPercent: "0.01024",
    bidSize: 100,
    bidPrice: "201.90",
    askSize: 100,
    askPrice: "202.10",
    volume: 33621,
    lastSalePrice: "201.00",
    lastSaleSize: 25,
    lastSaleTime: 1_477_050_435_000,
    lastUpdated: 1_477_050_435_000,
    lastReqTime: 1_477_050_435_000
  }
  @close_quote1 %Ticker.Quote{
    symbol: @symbol,
    marketPercent: "0.01024",
    bidSize: 100,
    bidPrice: "201.90",
    askSize: 100,
    askPrice: "202.10",
    volume: 33621,
    lastSalePrice: "199.00",
    lastSaleSize: 25,
    lastSaleTime: 1_477_050_440_000,
    lastUpdated: 1_477_050_440_000,
    lastReqTime: 1_477_050_440_000
  }

  @open_quote2 %Ticker.Quote{
    symbol: @symbol,
    marketPercent: "0.01024",
    bidSize: 100,
    bidPrice: "201.90",
    askSize: 100,
    askPrice: "202.10",
    volume: 33621,
    lastSalePrice: "199.00",
    lastSaleSize: 25,
    lastSaleTime: 1_477_050_485_000,
    lastUpdated: 1_477_050_485_000
  }
  @high_quote2 %Ticker.Quote{
    symbol: @symbol,
    marketPercent: "0.01024",
    bidSize: 100,
    bidPrice: "201.90",
    askSize: 100,
    askPrice: "202.10",
    volume: 33621,
    lastSalePrice: "200.00",
    lastSaleSize: 25,
    lastSaleTime: 1_477_050_490_000,
    lastUpdated: 1_477_050_490_000
  }
  @low_quote2 %Ticker.Quote{
    symbol: @symbol,
    marketPercent: "0.01024",
    bidSize: 100,
    bidPrice: "201.90",
    askSize: 100,
    askPrice: "202.10",
    volume: 33621,
    lastSalePrice: "197.00",
    lastSaleSize: 25,
    lastSaleTime: 1_477_050_495_000,
    lastUpdated: 1_477_050_495_000
  }
  @close_quote2 %Ticker.Quote{
    symbol: @symbol,
    marketPercent: "0.01024",
    bidSize: 100,
    bidPrice: "201.90",
    askSize: 100,
    askPrice: "202.10",
    volume: 33621,
    lastSalePrice: "199.00",
    lastSaleSize: 25,
    lastSaleTime: 1_477_050_500_000,
    lastUpdated: 1_477_050_500_000
  }

  test "get empty frame from quotes" do
    frame = Ticker.Frame.quotes_to_frame(nil, nil, [])
    assert frame == %Ticker.Frame{}
  end

  test "convert quotes to frame" do
    frame =
      Ticker.Frame.quotes_to_frame(@symbol, 1, [
        @open_quote1,
        @high_quote1,
        @skip_quote1,
        @close_quote1
      ])

    assert frame.open == @open_quote1
    assert frame.high == @high_quote1
    assert frame.low == @close_quote1
    assert frame.close == @close_quote1
  end

  test "bad quotes" do
    assert_raise(
      FunctionClauseError,
      "no function clause matching in Ticker.Frame.quotes_to_frame/3",
      fn ->
        Ticker.Frame.quotes_to_frame(@symbol, 1, @open_quote1)
      end
    )
  end

  test "get empty frame from frames" do
    frame = Ticker.Frame.frames_to_frame(nil, nil, [])
    assert frame == %Ticker.Frame{}
  end

  test "convert frames to frame" do
    frame1 =
      Ticker.Frame.quotes_to_frame(@symbol, 1, [
        @open_quote1,
        @high_quote1,
        @skip_quote1,
        @close_quote1
      ])

    frame2 =
      Ticker.Frame.quotes_to_frame(@symbol, 1, [
        @open_quote2,
        @high_quote2,
        @low_quote2,
        @close_quote2
      ])

    frame = Ticker.Frame.frames_to_frame(@symbol, 2, [frame1, frame2])
    assert frame.open == @open_quote1
    assert frame.high == @high_quote1
    assert frame.low == @low_quote2
    assert frame.close == @close_quote2
  end

  test "bad frames" do
    frame =
      Ticker.Frame.quotes_to_frame(@symbol, 1, [
        @open_quote1,
        @high_quote1,
        @skip_quote1,
        @close_quote1
      ])

    assert_raise(
      FunctionClauseError,
      "no function clause matching in Ticker.Frame.frames_to_frame/3",
      fn ->
        Ticker.Frame.frames_to_frame(@symbol, 1, frame)
      end
    )
  end
end
