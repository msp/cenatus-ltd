defmodule CenatusLtdWeb.BlogControllerTest do
  use CenatusLtdWeb.ConnCase

  alias CenatusLtdWeb.{Article, Category, Section}

  @valid_attrs %{
    title: "some blog title",
    summary: "some blog summary",
    content: "some blog content",
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

  setup :create_data

  test "lists all entries on index", context do
    conn = context[:conn]
    main_article = context[:main_article]
    related_article = context[:related_article]

    conn = get(conn, blog_path(conn, :index))
    assert html_response(conn, 200) =~ main_article.title
    assert html_response(conn, 200) =~ related_article.title
  end

  test "shows chosen resource", context do
    conn = context[:conn]
    main_article = context[:main_article]
    related_article = context[:related_article]

    related_article = Repo.preload(related_article, :tags)
    related_article = Repo.get(Article, related_article.id)

    conn = get(conn, blog_path(conn, :show, main_article))

    assert conn.assigns.article.id == main_article.id
    assert conn.assigns.related == [related_article]
    assert html_response(conn, 200) =~ main_article.title
  end

  test "renders page not found when id is nonexistent", context do
    conn = context[:conn]

    assert_error_sent(404, fn ->
      get(conn, blog_path(conn, :show, 9_999_999))
    end)
  end

  defp create_data(_context) do
    section = Repo.get_by(Section, name: "Blog")

    category =
      Category.changeset(%Category{name: "XR research"})
      |> Repo.insert!()

    main_article =
      Article.changeset(
        %Article{},
        Map.merge(@valid_attrs, %{
          title: "main blog XR article",
          section_id: section.id,
          category_id: category.id
        })
      )
      |> Repo.insert!()

    related_article =
      Article.changeset(
        %Article{},
        Map.merge(
          @valid_attrs,
          %{
            title: "related blog XR article (in the same category)",
            section_id: section.id,
            category_id: category.id
          }
        )
      )
      |> Repo.insert!()

    [
      section: section,
      category: category,
      main_article: main_article,
      related_article: related_article
    ]
  end
end
