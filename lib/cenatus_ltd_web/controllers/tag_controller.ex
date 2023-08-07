defmodule CenatusLtdWeb.TagController do
  use CenatusLtdWeb, :controller

  alias CenatusLtdWeb.Tag

  plug(CenatusLtdWeb.LoadAllTags)
  plug(:load_periodic)

  def index(conn, _params) do
    tags =
      Repo.all(from(tag in Tag, order_by: [asc: tag.name]))
      |> Repo.preload(:articles)
      |> Repo.preload(:tech_articles)

    render(conn, "index.html", tags: tags)
  end

  def new(conn, _params) do
    changeset = Tag.changeset(%Tag{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"tag" => tag_params}) do
    changeset = Tag.changeset(%Tag{}, tag_params)

    case Repo.insert(changeset) do
      {:ok, _tag} ->
        conn
        |> put_flash(:info, "Tag created successfully.")
        |> redirect(to: Routes.tag_path(conn, :index))

      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    tag =
      Repo.get!(Tag, id)
      |> Repo.preload(:articles)
      |> Repo.preload(:tech_articles)

    page_assigns = %{
      articles: tag.articles ++ tag.tech_articles,
      page_title: "'#{tag.name}' works"
    }

    conn
    |> put_view(CenatusLtdWeb.SharedView)
    |> render("articles.html", page_assigns)
  end

  def edit(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)
    changeset = Tag.changeset(tag)
    render(conn, "edit.html", tag: tag, changeset: changeset)
  end

  def update(conn, %{"id" => id, "tag" => tag_params}) do
    tag = Repo.get!(Tag, id)
    changeset = Tag.changeset(tag, tag_params)

    case Repo.update(changeset) do
      {:ok, tag} ->
        conn
        |> put_flash(:info, "Tag updated successfully.")
        |> redirect(to: Routes.tag_path(conn, :show, tag))

      {:error, changeset} ->
        render(conn, "edit.html", tag: tag, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    tag = Repo.get!(Tag, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(tag)

    conn
    |> put_flash(:info, "Tag deleted successfully.")
    |> redirect(to: Routes.tag_path(conn, :index))
  end

  defp load_periodic(conn, _options) do
    conn = assign(conn, :tweets, CenatusLtd.Periodically.tweets())
    assign(conn, :tracks, CenatusLtd.Periodically.tracks())
  end
end
