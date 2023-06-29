import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

# ## Using releases
#
# If you use `mix release`, you need to explicitly enable the server
# by passing the PHX_SERVER=true when you start it:
#
#     PHX_SERVER=true bin/<%= @app_name %> start
#
# Alternatively, you can use `mix phx.gen.release` to generate a `bin/server`
# script that automatically sets the env var above.


if config_env() == :prod do
  config :cenatus_ltd, CenatusLtdWeb.Endpoint,
    http: [port: System.get_env("PORT")],
    url: [scheme: "https", host: "cenatus.org", port: 443],
    force_ssl: [rewrite_on: [:x_forwarded_proto]],
    cache_static_manifest: "priv/static/cache_manifest.json",
    secret_key_base: System.get_env("SECRET_KEY_BASE")

  # Configure your database
  config :cenatus_ltd, CenatusLtd.Repo,
    url: System.get_env("DATABASE_URL"),
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true

  # AWS
  config :ex_aws,
    access_key_id: System.get_env("AWS_ACCESS_KEY_ID"),
    secret_access_key: System.get_env("AWS_SECRET_ACCESS_KEY"),
    region: "eu-central-1",
    debug_requests: true

  # Twitter App
  config :extwitter, :oauth,
    consumer_key: System.get_env("CONSUMER_KEY"),
    consumer_secret: System.get_env("CONSUMER_SECRET"),
    access_token: System.get_env("ACCESS_TOKEN"),
    access_token_secret: System.get_env("ACCESS_TOKEN_SECRET")

  config :elixirfm,
  api_key: System.get_env("LASTFM_API_KEY"),
  secret_key: System.get_env("LASTFM_SECRET_KEY")

  # ## SSL Support
    #
    # To get SSL working, you will need to add the `https` key
    # to your endpoint configuration:
    #
    #     config :<%= @web_app_name %>, <%= @endpoint_module %>,
    #       https: [
    #         ...,
    #         port: 443,
    #         cipher_suite: :strong,
    #         keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
    #         certfile: System.get_env("SOME_APP_SSL_CERT_PATH")
    #       ]
    #
    # The `cipher_suite` is set to `:strong` to support only the
    # latest and more secure SSL ciphers. This means old browsers
    # and clients may not be supported. You can set it to
    # `:compatible` for wider support.
    #
    # `:keyfile` and `:certfile` expect an absolute path to the key
    # and cert in disk or a relative path inside priv, for example
    # "priv/ssl/server.key". For all supported SSL configuration
    # options, see https://hexdocs.pm/plug/Plug.SSL.html#configure/1
    #
    # We also recommend setting `force_ssl` in your endpoint, ensuring
    # no data is ever sent via http, always redirecting to https:
    #
    #     config :<%= @web_app_name %>, <%= @endpoint_module %>,
    #       force_ssl: [hsts: true]
    #
    # Check `Plug.SSL` for all available options in `force_ssl`.<%= if @mailer do %>

    # ## Configuring the mailer
    #
    # In production you need to configure the mailer to use a different adapter.
    # Also, you may need to configure the Swoosh API client of your choice if you
    # are not using SMTP. Here is an example of the configuration:
    #
    #     config :<%= @app_name %>, <%= @app_module %>.Mailer,
    #       adapter: Swoosh.Adapters.Mailgun,
    #       api_key: System.get_env("MAILGUN_API_KEY"),
    #       domain: System.get_env("MAILGUN_DOMAIN")
    #
    # For this example you need include a HTTP client required by Swoosh API client.
    # Swoosh supports Hackney and Finch out of the box:
    #
    #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
    #
    # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.<% end %>

end
