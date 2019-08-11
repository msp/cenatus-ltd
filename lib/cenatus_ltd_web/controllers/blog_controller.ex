defmodule CenatusLtdWeb.BlogController do
  use CenatusLtdWeb, :controller

  alias CenatusLtdWeb.{Article, Section}

  plug(CenatusLtdWeb.LoadAllBlogTags)
  plug(CenatusLtdWeb.LoadAllSections)
  plug(CenatusLtdWeb.LoadAllCategories)
  plug(:load_periodic)

  def index(conn, _params) do
    blog_query =
      from(article in Article,
        join: s in assoc(article, :section),
        where: s.name == "Blog",
        order_by: [desc: article.published_at]
      )

    articles = Repo.all(blog_query)

    # TODO: MOve this back to index.html.haml page
    render(conn, CenatusLtdWeb.SharedView, "blog.html", articles: articles)
    # render(conn, "index.html", articles: blog.articles)
  end

  def show(conn, %{"id" => id}) do
    main_article =
      Repo.get!(Article, id)
      |> Repo.preload(:section)
      |> Repo.preload(:category)
      |> Repo.preload(:tags)
      |> Repo.preload(:tech_tags)

    category_query =
      from(article in Article,
        where: article.category_id == ^main_article.category_id,
        where: article.section_id == ^main_article.section_id,
        distinct: article.title
      )

    candidates = Repo.all(category_query)

    related_articles =
      if candidates do
        Enum.reject(candidates, fn a -> a.id == main_article.id end)
        |> Enum.uniq_by(fn c -> c.id end)
        |> Enum.take(10)
      else
        []
      end

    render(conn, "show.html", article: main_article, related: related_articles)
  end

  defp load_periodic(conn, _options) do
    conn = assign(conn, :tweets, CenatusLtd.Periodically.tweets())
    assign(conn, :tracks, CenatusLtd.Periodically.tracks())
  end
end
