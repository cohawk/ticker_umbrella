defmodule Fantasy do
  @moduledoc """
  Documentation for Fantasy.
  """
  use Application

  @id_length Application.get_env(:fantasy, :id_length)
  @id_words Application.get_env(:fantasy, :id_words)
  @id_number_max Application.get_env(:fantasy, :id_number_max)

  @name_number_max Application.get_env(:fantasy, :id_number_max)

  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    children = [
      supervisor(Fantasy.Game.Supervisor, []),
      worker(Fantasy.Game.Event, [])
    ]

    opts = [strategy: :one_for_one, name: Fantasy.Supervisor]
    Supervisor.start_link(children, opts)
  end

  @doc """
  Generates unique id for the game
  """
  def generate_player_id do
    @id_length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64()
    |> binary_part(0, @id_length)
  end

  @doc """
  Generates unique id for the game
  """
  def generate_game_id do
    Fantasy.Pirate.generate_id(@id_words, @id_number_max)
  end
end
