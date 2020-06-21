defmodule NarouBot.Mixfile do
  use Mix.Project

  def project do
    [
      app: :narou_bot,
      version: "0.0.1",
      elixir: "~> 1.4",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      start_permanent: Mix.env == :prod,
      preferred_cli_env: [espec: :test],
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {NarouBot.Application, []},
      extra_applications: [:logger, :runtime_tools]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "spec/support"]
  defp elixirc_paths(_),     do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:narou, git: "https://github.com/harukikubota/narou.git", tag: "0.2.3", override: true},
      {:phoenix, github: "phoenixframework/phoenix", branch: "master", override: true},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_ecto, ">= 4.1.0"},
      {:ecto, "~> 3.4.0"},
      {:ecto_sql, "~> 3.4.3"},
      {:ecto_enum, "~> 1.3"},
      {:postgrex, ">= 0.0.0"},
      {:phoenix_html, "~> 2.10"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:espec_phoenix, "~> 0.7.1", only: :test},
      {:gettext, "~> 0.11"},
      {:jason, "~> 1.0"},
      {:plug_cowboy, "~> 2.0"},
      {:httpoison, "~> 1.4"},
      {:poison, "~> 4.0", override: true},
      {:quantum, "~> 3.0"},
      {:tzdata, "~> 1.0.3"},
      {:line_bot, path: "ext_lib/line_bot"},
    ]
  end

  # Aliases are shortcuts or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    [
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate", "test"]
    ]
  end
end
