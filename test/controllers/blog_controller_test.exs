defmodule CenatusLtdWeb.BlogControllerTest do
  use CenatusLtdWeb.ConnCase

  alias CenatusLtdWeb.{Article, Section}

  @valid_attrs %{
    title: "some content title",
    summary: "some content summary",
    content: "some content",
    published_at: %DateTime{
      day: 17,
      month: 4,
      year: 2010,
      hour: 14,
      minute: 0,
      second: 0,
      time_zone: "Europe/London",
      zone_abbr: "GMT",
      utc_offset: 3600,
      std_offset: 0
    }
  }

  # test "lists all entries on index", %{conn: conn} do
  #   conn = get(conn, blog_path(conn, :index))
  #   assert html_response(conn, 200) =~ "Listing blog"
  # end

  test "shows chosen resource", %{conn: conn} do
    changeset =
      Section.changeset(
        %Section{},
        %{name: "Blog section
        "}
      )

    blog = Repo.insert!(changeset)

    changeset =
      Article.changeset(
        %Article{},
        Map.merge(@valid_attrs, %{title: "blog article", section_id: blog.id})
      )

    blog_article = Repo.insert!(changeset)

    # changeset =
    #   Article.changeset(
    #     %Article{},
    #     Map.merge(@valid_attrs, %{title: "another blog article", section_id: blog.id})
    #   )
    #
    # related_blog_article = Repo.insert!(changeset)
    # related_blog_article = Repo.get(Article, related_blog_article.id)

    conn = get(conn, article_path(conn, :show, blog_article))

    assert conn.assigns.article == blog_article
    # TODO! What will we show as related content? It's not by section, prob by Category or Tag
    # assert conn.assigns.related == [related_blog_article]
    assert html_response(conn, 200) =~ blog_article.title
  end

  # test "shows chosen resource", %{conn: conn} do
  #   blog = Repo.insert!(%Article{})
  #   conn = get(conn, blog_path(conn, :show, blog))
  #   assert html_response(conn, 200) =~ "Show blog"
  # end
  #
  # test "renders page not found when id is nonexistent", %{conn: conn} do
  #   assert_error_sent(404, fn ->
  #     get(conn, blog_path(conn, :show, -1))
  #   end)
  # end
end