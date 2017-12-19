defmodule Ticker.Mixfile do
  use Mix.Project

  def project do
    [
      app: :ticker,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.5",
      start_permanent: Mix.env == :prod,
      deps: deps(),
      aliases: [test: "test --no-start"],
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: ["coveralls": :test, "coveralls.detail": :test, "coveralls.post": :test, "coveralls.html": :test]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      mod: {Ticker, []},
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"},
      # {:sibling_app_in_umbrella, in_umbrella: true},

      {:timex, "~> 3.1"},
      # {:timex, git: "https://github.com/cohawk/timex.git"},
      {:poison, "~> 3.1"},
      {:httpoison, "~> 0.13.0"},
      {:excoveralls, "~> 0.5", only: :test},
      {:mock, "~> 0.2.0", only: :test}
    ]
  end

end
