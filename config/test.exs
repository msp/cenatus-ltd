use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :cenatus_ltd, CenatusLtdWeb.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Configure your database
if System.get_env("DATABASE_URL") do
  config :cenatus_ltd, CenatusLtd.Repo,
    adapter: Ecto.Adapters.Postgres,
    url: System.get_env("DATABASE_URL"),
    pool: Ecto.Adapters.SQL.Sandbox,
    ssl: true
else
  config :cenatus_ltd, CenatusLtd.Repo,
    adapter: Ecto.Adapters.Postgres,
    username: "cenatus-test",
    database: "cenatus_ltd_test",
    hostname: "localhost",
    pool: Ecto.Adapters.SQL.Sandbox
end

config :extwitter, :oauth,
  consumer_key: "foo",
  consumer_secret: "bar",
  access_token: "baz",
  access_token_secret: "qux"

config :elixirfm,
  api_key: "foo",
  secret_key: "bar"
