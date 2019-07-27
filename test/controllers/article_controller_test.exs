defmodule CenatusLtd.ArticleControllerTest do
  use CenatusLtd.ConnCase

  alias CenatusLtd.Article

  @valid_attrs %{
    title: "some content",
    summary: "some content",
    content: "some content",
    published_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}
  }

  @invalid_attrs %{}

  describe "authorized routes" do
    setup %{conn: conn} do
      admin_user = %CenatusLtd.User{id: 1, username: "admin"}
      {:ok, conn: assign(conn, :current_user, admin_user), user: admin_user}
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get(conn, article_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing articles"
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get(conn, article_path(conn, :new))
      assert html_response(conn, 200) =~ "New article"
    end

    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = post(conn, article_path(conn, :create), article: @valid_attrs)
      assert redirected_to(conn) == article_path(conn, :index)
      assert Repo.get_by(Article, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, article_path(conn, :create), article: @invalid_attrs)
      assert html_response(conn, 200) =~ "New article"
    end

    test "renders form for editing chosen resource", %{conn: conn} do
      article = Repo.insert!(%Article{title: "testing edit form title"})
      conn = get(conn, article_path(conn, :edit, article))
      assert html_response(conn, 200) =~ article.title
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
      article = Repo.insert!(%Article{})
      conn = put(conn, article_path(conn, :update, article), article: @valid_attrs)

      updated_article = Repo.get_by(Article, @valid_attrs)

      assert updated_article
      assert redirected_to(conn) == article_path(conn, :show, updated_article)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      article = Repo.insert!(%Article{})
      conn = put(conn, article_path(conn, :update, article), article: @invalid_attrs)

      assert html_response(conn, 200) =~
               "Oops, something went wrong! Please check the errors below"
    end

    test "deletes chosen resource", %{conn: conn} do
      article = Repo.insert!(%Article{})
      conn = delete(conn, article_path(conn, :delete, article))
      assert redirected_to(conn) == article_path(conn, :index)
      refute Repo.get(Article, article.id)
    end
  end

  describe "public routes" do
    test "shows chosen resource", %{conn: conn} do
      changeset =
        Article.changeset(
          %Article{},
          Map.merge(@valid_attrs, %{title: "main creative article", tags: "creative"})
        )

      main_article = Repo.insert!(changeset)

      changeset =
        Article.changeset(
          %Article{},
          Map.merge(@valid_attrs, %{title: "related creative article", tags: "creative"})
        )

      related_article = Repo.insert!(changeset)
      related_article = Repo.preload(related_article, :tags)
      related_article = Repo.get(Article, related_article.id)

      conn = get(conn, article_path(conn, :show, main_article))

      assert conn.assigns.article == main_article
      assert conn.assigns.related == [related_article]
      assert html_response(conn, 200) =~ main_article.title
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent(404, fn ->
        get(conn, article_path(conn, :show, 9_999_999))
      end)
    end
  end
end
