defmodule CenatusLtd.LoadAllCategories do
  import Plug.Conn
  import Ecto.Query

  alias CenatusLtd.Category
  alias CenatusLtd.Repo

  def init(default), do: default

  def call(conn, _default) do
    categories = Repo.all(Category) |> Repo.preload(:articles)

    assign(conn, :categories, categories)
  end
end
