require Logger

defmodule Ticker.Quote.Processor do

  alias Ticker.Quote.Util

  def quotes do
    Logger.info("Loading security quotes...")
    security_symbols = collect_security_symbols()
    {:ok, security_quotes} = process(security_symbols, false)

    Logger.info("Loading crypto quotes...")
    crypto_symbols = collect_crypto_symbols()
    {:ok, crypto_quotes} = process(crypto_symbols, true)

    combined_quotes = security_quotes ++ crypto_quotes
    {:ok, combined_quotes}
  end

  def historical do
    Logger.info("Loading security historical...")
    security_symbols = collect_security_symbols()
    {:ok, security_quotes} = historical(security_symbols, false)

    Logger.info("Loading crypto historical...")
    crypto_symbols = collect_crypto_symbols()
    {:ok, crypto_quotes} = historical(crypto_symbols, true)

    combined_quotes = security_quotes ++ crypto_quotes
    {:ok, combined_quotes}
  end

  def update({:ok, []}), do: Logger.info("No available quotes...")

  def update({:ok, quotes}) do
    quotes_updated = Enum.map(quotes, fn(q) ->
      if Ticker.Symbol.get_pid(q.symbol) == :empty do
        if Enum.member?(Application.get_env(:ticker, :security_symbols), q.symbol) do
          Ticker.Security.Supervisor.add_security(q.symbol)
        else
          Ticker.Crypto.Supervisor.add_crypto(q.symbol)
        end
      end
      q_update = case q.lastReqTime do
        lrt when lrt == nil -> %{q | lastReqTime: Util.to_unix_milli(Timex.now)}
        _                   -> q
      end
      Ticker.Symbol.add_quote(q_update.symbol, q_update)
      q_update
    end)
    {:ok, quotes_updated}
  end

  def update({:error, msg}) do
    Logger.error(msg)
  end

  defp collect_security_symbols do
    symbols = Application.get_env(:ticker, :security_symbols)
    Enum.map(symbols, fn(name) -> Ticker.Symbol.get_symbol(name) end)
  end

  defp collect_crypto_symbols do
    symbols = Application.get_env(:ticker, :crypto_symbols)
    Enum.map(symbols, fn(name) -> Ticker.Symbol.get_symbol(name) end)
  end

  defp process([], _) do
    Logger.info("No available symbols...")
    {:empty}
  end

  defp process(symbols, is_crypto) do
    processor = Application.get_env(:ticker, :processor)
    symbols
      |> processor.process(is_crypto)
      |> update
  end

  defp historical([], _) do
    Logger.info("No available symbols...")
    {:empty}
  end

  defp historical(symbols, is_crypto) do
    processor = Application.get_env(:ticker, :processor)
    symbols
      |> processor.historical(is_crypto)
      |> update
  end

end
