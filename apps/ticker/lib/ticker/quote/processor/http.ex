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

  # https://min-api.cryptocompare.com/data/pricemultifull?tsyms=USD&fsyms=BTC,ETH,LTC,XRP,BTH

  defp request(symbols) do
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
    # Get the keys for the RAW block which will be the Symbol list - discard DISPLAY
    #   Map.keys(get_in(map2, ["RAW"]))
    # Traverse the Symbol list and extract the USD block with is the actual Quote
    #   get_in(map2, ["RAW", x, "USD"])

    Enum.map(Map.keys(get_in(map2, ["RAW"])), fn(x) -> get_in(map2, ["RAW", x, "USD"]) end)

    ## TODO - convert this list of Quote Maps to list of Quote Struct

  end

end
