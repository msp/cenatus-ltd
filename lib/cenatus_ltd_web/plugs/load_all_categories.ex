defmodule CenatusLtdWeb.LoadAllCategories do
  import Plug.Conn

  alias CenatusLtdWeb.Category
  alias CenatusLtd.Repo

  def init(default), do: default

  def call(conn, _default) do
    categories = Repo.all(Category) |> Repo.preload(:articles)

    assign(conn, :categories, categories)
  end
end
