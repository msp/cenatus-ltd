defmodule CenatusLtd.ArticleTest do
  use CenatusLtd.ModelCase

  alias CenatusLtd.Article

  @valid_attrs %{
    content: "some content",
    published_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010},
    summary: "some summary",
    title: "some title",
    image_url: "http://res.cloudinary.com/cenatus/image/upload/w_auto/millco-site_xs8rep.jpg"
  }

  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Article.changeset(%Article{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Article.changeset(%Article{}, @invalid_attrs)
    refute changeset.valid?
  end

  describe "parse_tags_from:" do
    test "basic" do
      tags_list = "foo, bar, baz"
      result = Article.parse_tags_from(tags_list)
      assert result == ["foo", "bar", "baz"]
    end

    test "trims & case" do
      tags_list = " foo , Bar, bAZ  "
      result = Article.parse_tags_from(tags_list)
      assert result == ["foo", "bar", "baz"]
    end

    test "spaces" do
      tags_list = "foo bar, baz"
      result = Article.parse_tags_from(tags_list)
      assert result == ["foo bar", "baz"]
    end

    test "hyphens & underscores" do
      tags_list = "foo-bar, baz_bing"
      result = Article.parse_tags_from(tags_list)
      assert result == ["foo-bar", "baz_bing"]
    end
  end

  describe "tags:" do
    test "changeset with valid tags" do
      {:ok, article} =
        Article.changeset(%Article{}, Map.merge(@valid_attrs, %{tags: "foo, bar, baz"}))
        |> Repo.insert()

      assert Enum.map(article.tags, fn tag -> tag.name end) == ["foo", "bar", "baz"]
    end
  end

  describe "tech_tags:" do
    test "changeset with valid tech tags" do
      {:ok, article} =
        Article.changeset(
          %Article{},
          Map.merge(@valid_attrs, %{tags: "technology", tech_tags: "elixir, elm, js"})
        )
        |> Repo.insert()

      assert Enum.map(article.tags, fn tag -> tag.name end) == ["technology"]
      assert Enum.map(article.tech_tags, fn tag -> tag.name end) == ["elixir", "elm", "js"]
    end
  end

  describe "slugs" do
    test "slug created/updated" do
      {:ok, article} =
        Article.changeset(%Article{}, Map.merge(@valid_attrs, %{title: "original title"}))
        |> Repo.insert()

      assert article.slug == "original-title"

      {:ok, updated_article} =
        Article.changeset(article, Map.merge(@valid_attrs, %{title: "updated title"}))
        |> Repo.update()

      assert updated_article.slug == "updated-title"
    end
  end
end
