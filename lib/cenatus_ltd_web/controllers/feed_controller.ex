defmodule CenatusLtdWeb.FeedController do
  use CenatusLtdWeb, :controller

  def index(conn, _params) do
    article_query =
      from(article in CenatusLtdWeb.Article,
        preload: [:section, :category],
        order_by: [desc: article.published_at],
        limit: 300
      )

    articles = Repo.all(article_query)

    conn
    |> put_resp_content_type("application/xml")
    |> render("index.xml", items: articles)
  end
end
