defmodule CenatusLtd.Mixfile do
  use Mix.Project

  def project do
    [
      app: :cenatus_ltd,
      version: "0.0.1",
      elixir: "~> 1.14",
      elixirc_paths: elixirc_paths(Mix.env()),
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
      extra_applications: [:logger, :runtime_tools, :sitemap, :elixirfm]
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
      {:dart_sass, "~> 0.6", runtime: Mix.env() == :dev},
      {:earmark, "~> 1.2.2"},
      {:ecto_sql, "~> 3.12"},
      {:elixirfm, "~> 1.0.0"},
      {:esbuild, "~> 0.8", runtime: Mix.env() == :dev},
      {:ex_aws, "~> 1.0"},
      {:extwitter, "~> 0.12"},
      {:floki, ">= 0.30.0", only: :test},
      {:gettext, "~> 0.26"},
      {:hackney, "~> 1.6", override: true},
      {:html_sanitize_ex, "~> 1.4"},
      {:jason, "~> 1.2"},
      {:mix_test_watch, "~> 1.0", only: [:dev, :test], runtime: false},
      {:phoenix, "~> 1.7.21"},
      {:phoenix_ecto, "~> 4.5"},
      {:phoenix_html, "~> 4.1"},
      {:phoenix_html_helpers, "~> 1.0.1"},
      {:phoenix_live_reload, "~> 1.2", only: :dev},
      {:phoenix_live_view, "~> 1.0"},
      {:phoenix_live_dashboard, "~> 0.8.3"},
      {:phoenix_pubsub, "~> 2.0"},
      {:phoenix_view, "~> 2.0"},
      {:plug, "~> 1.7"},
      {:plug_cowboy, "~> 2.1"},
      {:poison, "~> 2.0", override: true},
      {:postgrex, ">= 0.0.0"},
      {:sitemap, "~> 0.9"},
      {:telemetry_metrics, "~> 1.0"},
      {:telemetry_poller, "~> 1.0"},
      {:timex,
       git: "https://github.com/gilbertwong96/timex.git",
       branch: "fix/compilation-warning",
       override: true}
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
      setup: ["deps.get", "ecto.setup"],
      "ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
      "ecto.reset": ["ecto.drop", "ecto.setup"],
      test: ["ecto.create --quiet", "ecto.migrate --quiet", "test"],
      "assets.deploy": [
        "esbuild default --minify",
        "sass default --no-source-map --style=compressed",
        "phx.digest"
      ]
    ]
  end
end
