defmodule CenatusLtdWeb.TagControllerTest do
  use CenatusLtdWeb.ConnCase

  alias CenatusLtdWeb.Tag
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  describe "authorized routes" do
    setup %{conn: conn} do
      admin_user = %CenatusLtdWeb.User{id: 1, username: "admin"}
      {:ok, conn: assign(conn, :current_user, admin_user), user: admin_user}
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get(conn, tag_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing tags"
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get(conn, tag_path(conn, :new))
      assert html_response(conn, 200) =~ "New tag"
    end

    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = post(conn, tag_path(conn, :create), tag: @valid_attrs)
      assert redirected_to(conn) == tag_path(conn, :index)
      assert Repo.get_by(Tag, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, tag_path(conn, :create), tag: @invalid_attrs)
      assert html_response(conn, 200) =~ "New tag"
    end

    test "renders form for editing chosen resource", %{conn: conn} do
      tag = Repo.insert!(%Tag{})
      conn = get(conn, tag_path(conn, :edit, tag))
      assert html_response(conn, 200) =~ "Edit tag"
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
      tag = Repo.insert!(%Tag{})
      conn = put(conn, tag_path(conn, :update, tag), tag: @valid_attrs)

      updated_tag = Repo.get_by(Tag, @valid_attrs)
      assert updated_tag
      assert redirected_to(conn) == tag_path(conn, :show, updated_tag)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      tag = Repo.insert!(%Tag{})
      conn = put(conn, tag_path(conn, :update, tag), tag: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit tag"
    end

    test "deletes chosen resource", %{conn: conn} do
      tag = Repo.insert!(%Tag{})
      conn = delete(conn, tag_path(conn, :delete, tag))
      assert redirected_to(conn) == tag_path(conn, :index)
      refute Repo.get(Tag, tag.id)
    end
  end

  describe "public routes" do
    test "shows chosen resource", %{conn: conn} do
      attrs = %{
        title: "some title",
        summary: "some content",
        content: "some content",
        image_url: "http://somewhere.com/tag/image.jpg",
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

      changeset =
        CenatusLtdWeb.Article.changeset(
          %CenatusLtdWeb.Article{},
          Map.merge(attrs, %{tags: "creativetag"})
        )

      article = Repo.insert!(changeset)

      conn = get(conn, tag_path(conn, :show, Enum.at(article.tags, 0)))
      assert html_response(conn, 200) =~ "creativetag"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent(404, fn ->
        get(conn, tag_path(conn, :show, 9_999_999))
      end)
    end
  end
end
