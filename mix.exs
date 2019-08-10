defmodule CenatusLtd.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cenatus_ltd,
      version: "0.0.1",
      elixir: "~> 1.2",
      elixirc_paths: elixirc_paths(Mix.env()),
      compilers: [:phoenix, :gettext] ++ Mix.compilers(),
      build_embedded: Mix.env() == :prod,
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps()
    ]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {CenatusLtd, []},
      applications: [
        :sitemap,
        :phoenix,
        :phoenix_pubsub,
        :phoenix_html,
        :cowboy,
        :logger,
        :gettext,
        :phoenix_ecto,
        :postgrex,
        :comeonin,
        :ex_aws,
        :hackney,
        :poison,
        :extwitter,
        :elixirfm
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:comeonin, "~> 2.0"},
      {:earmark, "~> 1.2.2"},
      {:ecto_sql, "~> 3.0"},
      {:elixirfm, "~> 0.0.10"},
      {:ex_aws, "~> 1.0"},
      {:extwitter, "~> 0.8"},
      {:floki, "~> 0.21.0"},
      {:gettext, "~> 0.11"},
      {:hackney, "~> 1.6", override: true},
      {:html_sanitize_ex, "~> 1.2"},
      {:jason, "~> 1.0"},
      {:mix_test_watch, "~> 0.3", only: :dev, runtime: false},
      {:phoenix, "~> 1.4.0"},
      {:phoenix_ecto, "~> 4.0"},
      {:phoenix_haml, "~> 0.2.1"},
      {:phoenix_html, "~> 2.10.3"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:phoenix_pubsub, "~> 1.0"},
      {:plug, "~> 1.7"},
      {:plug_cowboy, "~> 2.0"},
      {:poison, "~> 2.0", override: true},
      {:postgrex, ">= 0.0.0"},
      {:sitemap, "~> 0.9"},
      {:timex, "~> 3.0"},
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
      test: ["ecto.migrate", "test"]
    ]
  end
end
