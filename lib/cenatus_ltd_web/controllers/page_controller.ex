defmodule CenatusLtdWeb.PageController do
  use CenatusLtdWeb, :controller

  require Logger

  alias CenatusLtdWeb.Article

  plug(CenatusLtdWeb.LoadAllTags)
  plug(:load_periodic)

  def home(conn, _params) do
    articles = get_articles_tagged_by("featured")

    if length(articles) == 0 do
      _articles =
        Repo.all(
          from(article in Article,
            limit: 2,
            order_by: [desc: article.published_at]
          )
        )
    end

    conn
    |> put_view(CenatusLtdWeb.SharedView)
    |> render("articles.html", articles: articles)
  end

  def creative(conn, _params) do
    articles = get_articles_tagged_by("creative")

    conn
    |> put_view(CenatusLtdWeb.SharedView)
    |> render("articles.html", articles: articles)
  end

  def technology(conn, _params) do
    articles = get_articles_tagged_by("technology")

    conn
    |> put_view(CenatusLtdWeb.SharedView)
    |> render("articles.html", articles: articles)
  end

  def production(conn, _params) do
    articles = get_articles_tagged_by("production")

    conn
    |> put_view(CenatusLtdWeb.SharedView)
    |> render("articles.html", articles: articles)
  end

  def people(conn, _params) do
    articles = get_articles_tagged_by("person")

    conn
    |> put_view(CenatusLtdWeb.SharedView)
    |> render("articles.html", articles: articles)
  end

  def about(conn, _params) do
    articles = get_articles_tagged_by("about")

    conn
    |> put_view(CenatusLtdWeb.SharedView)
    |> render("articles.html", articles: articles)
  end

  def admin(conn, _params) do
    render(conn, "admin.html")
  end

  def contact(conn, _params) do
    render(conn, "contact.html")
  end

  defp get_articles_tagged_by(tag_name) do
    Repo.all(
      from(a in Article,
        join: t in assoc(a, :tags),
        preload: [tags: t],
        where: t.name in ^[tag_name],
        order_by: [desc: a.published_at]
      )
    )
  end

  defp load_periodic(conn, _options) do
    conn = assign(conn, :tweets, CenatusLtd.Periodically.tweets())
    assign(conn, :tracks, CenatusLtd.Periodically.tracks())
  end
end
