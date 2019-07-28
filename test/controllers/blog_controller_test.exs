defmodule CenatusLtd.BlogControllerTest do
  use CenatusLtd.ConnCase

  alias CenatusLtd.{Article, Section}

  @valid_attrs %{
    title: "some content title",
    summary: "some content summary",
    content: "some content",
    published_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}
  }
  @invalid_attrs %{}

  # test "lists all entries on index", %{conn: conn} do
  #   conn = get(conn, blog_path(conn, :index))
  #   assert html_response(conn, 200) =~ "Listing blog"
  # end

  test "shows chosen resource", %{conn: conn} do
    changeset =
      Section.changeset(
        %Section{},
        %{name: "Blog"}
      )

    blog = Repo.insert!(changeset)

    changeset =
      Article.changeset(
        %Article{},
        Map.merge(@valid_attrs, %{title: "blog article", section_id: blog.id})
      )

    blog_article = Repo.insert!(changeset)

    changeset =
      Article.changeset(
        %Article{},
        Map.merge(@valid_attrs, %{title: "another blog article", section_id: blog.id})
      )

    related_blog_article = Repo.insert!(changeset)
    # related_blog_article = Repo.preload(related_article, :tags)
    related_blog_article = Repo.get(Article, related_blog_article.id)

    conn = get(conn, article_path(conn, :show, blog_article))

    assert conn.assigns.article == blog_article
    # TODO!
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
