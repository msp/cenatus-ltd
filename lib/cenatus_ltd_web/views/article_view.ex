defmodule CenatusLtdWeb.ArticleView do
  use CenatusLtdWeb, :view

  def render_tags_as_links_from(conn, tags) do
    tag_as_link = fn tag ->
      content_tag(
        :span,
        content_tag(:a, tag.name,
          href: tag_path(conn, :show, tag),
          class: ""
        ),
        class: "tag"
      )
    end

    Enum.map(tags, tag_as_link)
  end

  def render_categories_as_links_from(conn, categories) do
    category_as_link = fn category ->
      content_tag(
        :span,
        content_tag(:a, category.name,
          href: category_path(conn, :show, category),
          class: ""
        ),
        class: "category"
      )
    end

    Enum.map(categories, category_as_link)
  end

  def tags_list(tags) do
    Enum.map(tags, fn tag -> tag.name end)
    |> Enum.join(",")
  end
end
