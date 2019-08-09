defmodule CenatusLtd.SharedView do
  use CenatusLtd.Web, :view

  def handler_info(conn) do
    action_name(conn)
  end

  def render_page_title(conn) do
    if conn.assigns[:page_title] do
      content_tag(
        :h4,
        conn.assigns[:page_title],
        class: "tag_page_title"
      )
    else
      content_tag(
        :span,
        "",
        class: ""
      )
    end
  end

  def rss_date(article) do
    Timex.format!(article.inserted_at, "%a, %d %b %Y %H:%M:%S GMT", :strftime)
  end
end
