require Logger

defmodule Ticker.Quote.Processor.HTTP do

  @behaviour Ticker.Quote.Processor.Behaviour

  @doc "Process the given symbols (@see Ticker.Quote.Processor.Behaviour.process}"
  def process(symbols, is_crypto) do
    symbols
      |> fetch(is_crypto)
      |> decode(is_crypto)
  end

  @doc "Currently historical not implemented here (@see Ticker.Quote.Processor.Behaviour.historical)"
  def historical(_, _), do: []

  defp fetch(symbols, is_crypto) do
    case request(symbols, is_crypto) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, body}
      {:ok, %HTTPoison.Response{status_code: 400}} -> {:error, "Bad Request..."}
      {:ok, %HTTPoison.Response{status_code: 404}} -> {:error, "Not Found..."}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, IO.inspect reason}
    end
  end

  defp request(symbols, is_crypto) do
    # https://min-api.cryptocompare.com/data/pricemultifull?tsyms=USD&fsyms=BTC,ETH,LTC,XRP,BTH
    # TODO - add support for financial systems based on user pref - tsysm = USD, EUR, CYN, BTC, etc

    base_url = 
      case is_crypto do
        true -> Application.get_env(:ticker, :crypto_url)
        false -> Application.get_env(:ticker, :iextrading_url)
      end
    params = Enum.join(symbols, "%2C")
    url = "#{base_url}#{params}"
    HTTPoison.get(url)
  end

  defp decode({:error, _} = ret, _) do
    ret
  end

  defp decode({:ok, body}, is_crypto) do
    if is_crypto do

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
    else
      {:ok, Poison.decode!(body, as: [%Ticker.Quote{}])}
    end
  end

end
