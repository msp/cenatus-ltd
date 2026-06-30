defmodule CenatusLtd do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    children = [
      {Phoenix.PubSub, name: CenatusLtd.PubSub},
      CenatusLtd.Repo,
      CenatusLtdWeb.Endpoint,
      {CenatusLtd.Periodically, %{}}
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CenatusLtdWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CenatusLtdWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
