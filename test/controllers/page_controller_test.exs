defmodule CenatusLtdWeb.PageControllerTest do
  use CenatusLtdWeb.ConnCase

  test "GET /", %{conn: conn} do
    creative_article = insert_article(%{"title" => "creative article"})
    technology_article = insert_article(%{"title" => "technology article"})
    production_article = insert_article(%{"title" => "production article"})

    conn = get conn, "/"

    assert String.contains?(conn.resp_body, creative_article.title)
    assert String.contains?(conn.resp_body, technology_article.title)

    refute String.contains?(conn.resp_body, production_article.title)
  end

  test "GET tag specific pages", %{conn: conn} do
    creative_article = insert_article(%{"title" => "creative article", "tags" => "creative"})
    technology_article = insert_article(%{"title" => "technology article", "tags" => "creative, technology"})
    production_article = insert_article(%{"title" => "production article", "tags" => "production"})

    conn = get conn, "/creative"

    assert String.contains?(conn.resp_body, creative_article.title)
    assert String.contains?(conn.resp_body, technology_article.title)

    refute String.contains?(conn.resp_body, production_article.title)

    conn = get conn, "/technology"

    assert String.contains?(conn.resp_body, technology_article.title)

    refute String.contains?(conn.resp_body, creative_article.title)
    refute String.contains?(conn.resp_body, production_article.title)

    conn = get conn, "/production"

    assert String.contains?(conn.resp_body, production_article.title)

    refute String.contains?(conn.resp_body, creative_article.title)
    refute String.contains?(conn.resp_body, technology_article.title)
  end

  test "GET /people", %{conn: conn} do
    matt_article = insert_article(%{"title" => "matt spendlove", "tags" => "person"})
    andi_article = insert_article(%{"title" => "andi studer", "tags" => "person"})
    production_article = insert_article(%{"title" => "production article", "tags" => "production"})

    conn = get conn, "/people"

    assert String.contains?(conn.resp_body, matt_article.title)
    assert String.contains?(conn.resp_body, andi_article.title)

    refute String.contains?(conn.resp_body, production_article.title)
  end
end
