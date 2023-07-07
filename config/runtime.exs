import Config

# config/runtime.exs is executed for all environments, including
# during releases. It is executed after compilation and before the
# system starts, so it is typically used to load production configuration
# and secrets from environment variables or elsewhere. Do not define
# any compile-time configuration in here, as it won't be applied.
# The block below contains prod specific runtime configuration.

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  config :cenatus_ltd, CenatusLtd.Repo,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10"),
    ssl: true

  # The secret key base is used to sign/encrypt cookies and other secrets.
  # A default value is used in config/dev.exs and config/test.exs but you
  # want to use a different value for prod and you most likely don't want
  # to check this value into version control, so we use an environment
  # variable instead.
  secret_key_base =
    System.get_env("SECRET_KEY_BASE") ||
      raise """
      environment variable SECRET_KEY_BASE is missing.
      You can generate one by calling: mix phx.gen.secret
      """

  config :cenatus_ltd, CenatusLtdWeb.Endpoint,
    http: [port: System.get_env("PORT")],
    url: [scheme: "https", host: "cenatus.org", port: 443],
    force_ssl: [rewrite_on: [:x_forwarded_proto]],
    cache_static_manifest: "priv/static/cache_manifest.json",
    secret_key_base: secret_key_base

  # ## Using releases
    #
    # If you are doing OTP releases, you need to instruct Phoenix
    # to start each relevant endpoint:
    #
    #     config :esbuild_reference, EsbuildReferenceWeb.Endpoint, server: true
    #
    # Then you can assemble a release by calling `mix release`.
    # See `mix help release` for more information.

  # ## Configuring the mailer
  #
  # In production you need to configure the mailer to use a different adapter.
  # Also, you may need to configure the Swoosh API client of your choice if you
  # are not using SMTP. Here is an example of the configuration:
  #
  #     config :esbuild_reference, EsbuildReference.Mailer,
  #       adapter: Swoosh.Adapters.Mailgun,
  #       api_key: System.get_env("MAILGUN_API_KEY"),
  #       domain: System.get_env("MAILGUN_DOMAIN")
  #
  # For this example you need include a HTTP client required by Swoosh API client.
  # Swoosh supports Hackney and Finch out of the box:
  #
  #     config :swoosh, :api_client, Swoosh.ApiClient.Hackney
  #
  # See https://hexdocs.pm/swoosh/Swoosh.html#module-installation for details.

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
end
