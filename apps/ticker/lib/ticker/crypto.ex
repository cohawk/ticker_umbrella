require Logger

defmodule Ticker.Crypto.Supervisor do
  use Supervisor

  def start_link(empty) when empty do
    Logger.info("Starting Crypto Supervisor (NO Symbols)...")
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def start_link do
    Logger.info("Starting Crypto Supervisor...")
    {:ok, pid} = Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
    add_config_cryptos()
    {:ok, pid}
  end

  def add_crypto(symbol) do
    Supervisor.start_child(__MODULE__, [symbol])
  end

  def add_cryptos(symbols) do
    Enum.each(symbols, fn(s) -> add_crypto(s) end)
  end

  defp add_config_cryptos do
    symbols = Application.get_env(:ticker, :crypto_symbols)
    add_cryptos(symbols)
  end


  ## Server callbacks

  def init(:ok) do
    children = [
      supervisor(Ticker.Symbol.Supervisor, [], restart: :transient)
    ]
    supervise(children, strategy: :simple_one_for_one)
  end

end
