defmodule CenatusLtd.TagControllerTest do
  use CenatusLtd.ConnCase

  alias CenatusLtd.Tag
  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  describe "authorized routes" do
    setup %{conn: conn} do
      admin_user = %CenatusLtd.User{id: 1, username: "admin"}
      {:ok, conn: assign(conn, :current_user, admin_user), user: admin_user}
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get conn, tag_path(conn, :index)
      assert html_response(conn, 200) =~ "Listing tags"
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get conn, tag_path(conn, :new)
      assert html_response(conn, 200) =~ "New tag"
    end

    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = post conn, tag_path(conn, :create), tag: @valid_attrs
      assert redirected_to(conn) == tag_path(conn, :index)
      assert Repo.get_by(Tag, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post conn, tag_path(conn, :create), tag: @invalid_attrs
      assert html_response(conn, 200) =~ "New tag"
    end
    test "renders form for editing chosen resource", %{conn: conn} do
      tag = Repo.insert! %Tag{}
      conn = get conn, tag_path(conn, :edit, tag)
      assert html_response(conn, 200) =~ "Edit tag"
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
      tag = Repo.insert! %Tag{}
      conn = put conn, tag_path(conn, :update, tag), tag: @valid_attrs

      updated_tag = Repo.get_by(Tag, @valid_attrs)
      assert updated_tag
      assert redirected_to(conn) == tag_path(conn, :show, updated_tag)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      tag = Repo.insert! %Tag{}
      conn = put conn, tag_path(conn, :update, tag), tag: @invalid_attrs
      assert html_response(conn, 200) =~ "Edit tag"
    end

    test "deletes chosen resource", %{conn: conn} do
      tag = Repo.insert! %Tag{}
      conn = delete conn, tag_path(conn, :delete, tag)
      assert redirected_to(conn) == tag_path(conn, :index)
      refute Repo.get(Tag, tag.id)
    end
  end

  describe "public routes" do
    test "shows chosen resource", %{conn: conn} do
      attrs =  %{title: "some title", summary: "some content", content: "some content", published_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}}
      changeset = CenatusLtd.Article.changeset(%CenatusLtd.Article{}, Map.merge(attrs, %{tags: "creative"}))
      article = Repo.insert! changeset

      conn = get conn, tag_path(conn, :show, Enum.at(article.tags, 0))
      assert html_response(conn, 200) =~ "''"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent 404, fn ->
        get conn, tag_path(conn, :show, 9999999)
      end
    end
  end
end
