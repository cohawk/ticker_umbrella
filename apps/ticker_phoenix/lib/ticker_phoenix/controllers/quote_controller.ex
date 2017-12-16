defmodule TickerPhoenix.QuoteController do
   use TickerPhoenix, :controller

  def show(conn, %{"symbol" => symbol}) do
    render(conn, "show.json", quote: Ticker.Symbol.get_quote(symbol))
  end

end
