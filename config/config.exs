# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
import Config

# General application configuration
config :cenatus_ltd,
  ecto_repos: [CenatusLtd.Repo]

# Configures the endpoint
config :cenatus_ltd, CenatusLtdWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "jiBBNx/vDs11KHYmGbS6RGTAaINvSZBRyRGQTHwJWYCrJks+4AtTOCt+vkz5xAfR",
  render_errors: [view: CenatusLtdWeb.ErrorView, accepts: ~w(html json)],
  pubsub_server: CenatusLtd.PubSub

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix (1.4 upgrade)
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
