defmodule CenatusLtd.LoadAllSections do
  import Plug.Conn
  import Ecto.Query

  alias CenatusLtd.Section
  alias CenatusLtd.Repo

  def init(default), do: default

  def call(conn, _default) do
    sections = Repo.all(Section) |> Repo.preload(:articles)

    assign(conn, :sections, sections)
  end
end
