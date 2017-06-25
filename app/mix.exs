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
     deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {Sense, []},
     applications: [:phoenix, :phoenix_pubsub, :phoenix_html, :cowboy, :logger, :gettext,
                    :phoenix_ecto, :postgrex, :ex_machina, :logger, :faker, :comeonin, :instream, :corsica]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(:ci), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [ 
      # Base deps from Phoenix project
      {:phoenix, "~> 1.2.4"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.0"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},

      # Authentication
      {:comeonin, "~> 3.0.2"},
      {:guardian, "~> 0.14.4"},
      
      # Testing and seeding data
      {:ex_machina, "~> 2.0"},  
      {:faker, "~> 0.8", only: [:dev, :test, :ci]},

      #Time Series database
      {:instream, "~> 0.15" },

      #CORS
      {:plug, "~> 1.0"},
      {:corsica, "~> 1.0"}
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do 
    ["ecto.setup": ["ecto.create", "ecto.migrate", "ecto.seeds"],
     "ecto.seeds": ["run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
     "test": ["deps.get", "ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
