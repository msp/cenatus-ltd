defmodule CenatusLtdWeb.TagTest do
  use CenatusLtdWeb.ModelCase

  alias CenatusLtdWeb.Tag

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tag.changeset(%Tag{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tag.changeset(%Tag{}, @invalid_attrs)
    refute changeset.valid?
  end

  describe "slugs" do
    test "slug created/updated" do
        {:ok, tag} = Tag.changeset(%Tag{}, Map.merge(@valid_attrs, %{name: "original name"}))
        |> Repo.insert

      assert tag.slug == "original-name"

        {:ok, updated_tag} = Tag.changeset(tag, Map.merge(@valid_attrs, %{name: "updated name"}))
        |> Repo.update

      assert updated_tag.slug == "updated-name"
    end
  end

end
