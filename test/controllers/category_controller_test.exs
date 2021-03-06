defmodule CenatusLtdWeb.CategoryControllerTest do
  use CenatusLtdWeb.ConnCase

  alias CenatusLtdWeb.Category
  @valid_attrs %{name: "XR"}
  @invalid_attrs %{}

  describe "authorized routes" do
    setup %{conn: conn} do
      admin_user = %CenatusLtdWeb.User{id: 1, username: "admin"}
      {:ok, conn: assign(conn, :current_user, admin_user), user: admin_user}
    end

    test "lists all entries on index", %{conn: conn} do
      conn = get(conn, category_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing categories"
    end

    test "renders form for new resources", %{conn: conn} do
      conn = get(conn, category_path(conn, :new))
      assert html_response(conn, 200) =~ "New category"
    end

    test "creates resource and redirects when data is valid", %{conn: conn} do
      conn = post(conn, category_path(conn, :create), category: @valid_attrs)
      assert redirected_to(conn) == category_path(conn, :index)
      assert Repo.get_by(Category, @valid_attrs)
    end

    test "does not create resource and renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, category_path(conn, :create), category: @invalid_attrs)
      assert html_response(conn, 200) =~ "New category"
    end

    test "renders form for editing chosen resource", %{conn: conn} do
      category = Repo.insert!(%Category{})
      conn = get(conn, category_path(conn, :edit, category))
      assert html_response(conn, 200) =~ "Edit category"
    end

    test "updates chosen resource and redirects when data is valid", %{conn: conn} do
      category = Repo.insert!(%Category{})
      conn = put(conn, category_path(conn, :update, category), category: @valid_attrs)

      updated_category = Repo.get_by(Category, @valid_attrs)
      assert updated_category
      assert redirected_to(conn) == category_path(conn, :show, updated_category)
    end

    test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
      category = Repo.insert!(%Category{})
      conn = put(conn, category_path(conn, :update, category), category: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit category"
    end

    test "deletes chosen resource", %{conn: conn} do
      category = Repo.insert!(%Category{})
      conn = delete(conn, category_path(conn, :delete, category))
      assert redirected_to(conn) == category_path(conn, :index)
      refute Repo.get(Category, category.id)
    end
  end

  describe "public routes" do
    test "shows chosen resource", %{conn: conn} do
      category = Repo.insert!(%Category{name: "VR"})
      conn = get(conn, category_path(conn, :show, category))
      assert html_response(conn, 200) =~ "VR"
    end

    test "renders page not found when id is nonexistent", %{conn: conn} do
      assert_error_sent(404, fn ->
        get(conn, section_path(conn, :show, 9_999_999))
      end)
    end
  end
end
