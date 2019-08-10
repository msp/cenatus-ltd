defmodule CenatusLtdWeb.FeedController do
  use CenatusLtdWeb, :controller

  def index(conn, _params) do
    posts =
      Repo.all(
        from(
          p in CenatusLtdWeb.Article,
          order_by: [desc: p.published_at],
          preload: [:section, :category],
          limit: 300
        )
      )

    conn
    |> put_resp_content_type("application/xml")
    |> render("index.xml", items: posts)
  end
end
