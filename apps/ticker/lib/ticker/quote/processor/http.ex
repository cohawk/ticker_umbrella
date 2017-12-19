require Logger

defmodule Ticker.Quote.Processor.HTTP do

  @behaviour Ticker.Quote.Processor.Behaviour

  @doc "Process the given symbols (@see Ticker.Quote.Processor.Behaviour.process}"
  def process(symbols) do
    symbols
      |> fetch
      |> decode
  end

  @doc "Currently historical not implemented here (@see Ticker.Quote.Processor.Behaviour.historical)"
  def historical(_), do: []

  defp fetch(symbols) do
    case request(symbols) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 400}} -> {:error, "Bad Request..."}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, "Not Found..."}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, IO.inspect reason}
    end
  end

  defp request(symbols) do
    # https://min-api.cryptocompare.com/data/pricemultifull?tsyms=USD&fsyms=BTC,ETH,LTC,XRP,BTH
    # TODO - add support for financial systems based on user pref - tsysm = USD, EUR, CYN, BTC, etc
    base_url = Application.get_env(:ticker, :crypto_url)
    params = Enum.join(symbols, "%2C")
    url = "#{base_url}#{params}"
    HTTPoison.get(url)
  end

  defp decode({:error, _} = ret) do
    ret
  end

  defp decode({:ok, body}) do
    # {:ok, Poison.decode!(body, as: [%Ticker.Quote{}])}

    # JSON Data from min-api.cryptocompare.com
    #
    #  {
    #    RAW: {
    #      BTC: {
    #        USD: {...}
    #      },
    #      ETH: {
    #        USD: {...}
    #      }
    #    },
    #    DISPLAY: {
    #      BTC: {
    #        USD: {...}
    #      }
    #      ETH: {
    #        USD: {...}
    #      }
    #    }
    #  }
    # 

    raw_json = Poison.decode!(body)

    # Get the keys for the RAW block which will be the Symbol list - discard DISPLAY
    symbol_list = Map.keys(get_in(raw_json, ["RAW"]))

    # Traverse the Symbol list and extract the USD block with is the actual Quote
    # TODO - add support for financial systems based on user pref - tsysm = USD, EUR, CYN, BTC, etc
    #   get_in(raw_json, ["RAW", x, "USD"])
    quotes = Enum.map(symbol_list, fn(x) -> get_in(raw_json, ["RAW", x, "USD"]) end)

    # Convert this list of Quote Maps to list of Quote Struct
    quotes_struct_list = Enum.map(quotes, fn(x) -> Ticker.Quote.from_crypto(x) end)

    {:ok, quotes_struct_list}
  end

end
