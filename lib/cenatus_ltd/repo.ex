defmodule CenatusLtd.Repo do
  use Ecto.Repo,
    otp_app: :cenatus_ltd,
    adapter: Ecto.Adapters.Postgres
end
