defmodule Ticker.Notify.Frame.Test do
  use ExUnit.Case, async: false

  @symbol "TSLA"
  @frame %Ticker.Frame{
    open: %Ticker.Quote{
      symbol: @symbol,
      marketPercent: "0.01024",
      bidSize: 100,
      bidPrice: "201.90",
      askSize: 100,
      askPrice: "202.10",
      volume: 33621,
      lastSalePrice: "199.00",
      lastSaleSize: 25,
      lastSaleTime: 1_477_050_560_000,
      lastUpdated: 1_477_050_560_000,
      lastReqTime: 1_477_050_560_000
    },
    high: %Ticker.Quote{
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
      lastUpdated: 1_477_050_490_000,
      lastReqTime: 1_477_050_490_000
    },
    low: %Ticker.Quote{
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
      lastUpdated: 1_477_050_495_000,
      lastReqTime: 1_477_050_495_000
    },
    close: %Ticker.Quote{
      symbol: @symbol,
      marketPercent: "0.01024",
      bidSize: 100,
      bidPrice: "201.90",
      askSize: 100,
      askPrice: "202.10",
      volume: 33621,
      lastSalePrice: "197.00",
      lastSaleSize: 25,
      lastSaleTime: 1_477_050_500_000,
      lastUpdated: 1_477_050_500_000,
      lastReqTime: 1_477_050_500_000
    }
  }

  def notify_frame_test_callback(frame) do
    assert frame == @frame
  end

  #####
  # Notify Frame Client Interface

  test "init" do
    Ticker.Notify.Frame.start_link()
    notify_frame_pid = Process.whereis(Ticker.Notify.Frame)
    assert is_pid(notify_frame_pid)
  end

  test "notify frame interface" do
    {:ok, _} = Ticker.Notify.Frame.start_link()
    assert Ticker.Notify.Frame.notify(@frame) == :ok
  end

  #####
  # Notify Frame Server Interface

  test "notify frame" do
    Application.put_env(
      :ticker,
      :frame_notify,
      [notify_module: Ticker.Notify.Frame.Test, notify_fn: :notify_frame_test_callback],
      persistent: true
    )

    state = %{}
    {:noreply, finalstate} = Ticker.Notify.Frame.handle_cast({:notify, @frame}, state)
    assert finalstate == state
  end

  test "notify frame -- no module configured" do
    Application.put_env(
      :ticker,
      :frame_notify,
      [notify_module: nil, notify_fn: :notify_frame_test_callback],
      persistent: true
    )

    state = %{}
    {:noreply, finalstate} = Ticker.Notify.Frame.handle_cast({:notify, @frame}, state)
    assert finalstate == state
  end

  test "notify frame -- no callback configured" do
    Application.put_env(
      :ticker,
      :frame_notify,
      [notify_module: Ticker.Notify.Frame.Test, notify_fn: nil],
      persistent: true
    )

    state = %{}
    {:noreply, finalstate} = Ticker.Notify.Frame.handle_cast({:notify, @frame}, state)
    assert finalstate == state
  end
end
