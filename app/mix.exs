defmodule Sense.Mixfile do
  use Mix.Project

  def project do
    [app: :sense,
     version: "0.0.1",
     elixir: "~> 1.2",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix, :gettext] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases(),
     test_coverage: [tool: ExCoveralls],
     preferred_cli_env: [
       "coveralls": :test,
       "coveralls.detail": :test,
       "coveralls.post": :test,
       "coveralls.html": :test ],
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Sense, []},
     applications: [:rollbax, :tortoise, :corsica, :phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :postgrex, :ex_machina, :logger, :faker, :instream, :ecto_sql]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      # Base deps from Phoenix project
      {:phoenix, "~> 1.4.6"},
      {:phoenix_pubsub, "~> 1.1.2"},
      {:ecto_sql, "~> 3.1.4"},
      {:phoenix_ecto, "~> 4.0.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.13.3"},
      {:phoenix_live_reload, "~> 1.2.1", only: :dev},
      {:gettext, "~> 0.16.1"},
      {:plug_cowboy, "~> 2.0.2"},

      # Testing and seeding data
      {:ex_machina, "~> 2.3"},
      {:faker, "~> 0.12"},
      {:excoveralls, "~> 0.11.1", only: [:test]},
      {:junit_formatter, "~> 3.0", only: [:test]},

      #Time Series database
      {:instream, "~> 0.21" },

      #CORS
      {:plug, "~> 1.8"},
      {:corsica, "~> 1.1.2"},

      #MQTT
      {:tortoise, "~> 0.9.4"},

      #LINTER
      {:credo, "~> 1.0.5", only: [:dev, :test], runtime: false},

      #Error reporting
      {:rollbax, ">= 0.10.0"},

      #to check
      # Authentication
      # {:phoenix_oauth2_provider, "~> 0.5.1"},
      # {:phoenix_swagger, "~> 0.8.1"}
      # {:open_api_spex, "~> 3.3"}
      # {:cowboy_swagger, "~> 2.1"}
      # {:edh_phoenix_swagger, "~> 0.2.1"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate"],
     "ecto.seeds": ["run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["deps.get", "ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
