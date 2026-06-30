defmodule CenatusLtdWeb.LoadPeriodic do
  import Plug.Conn

  def init(default), do: default

  def call(conn, _default) do
    conn
    |> assign(:posts, CenatusLtd.Periodically.posts())
    |> assign(:tracks, CenatusLtd.Periodically.tracks())
  end
end
