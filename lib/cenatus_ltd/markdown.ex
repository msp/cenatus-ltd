defmodule CenatusLtd.Markdown do
  alias CenatusLtd.Cache

  @base_url "http://cenatus.org"

  def to_html(markdown) do
    markdown
    |> Earmark.as_html!(%Earmark.Options{code_class_prefix: "language-"})
    |> HtmlSanitizeEx.markdown_html()
    |> expand_relative_links(@base_url)
    |> String.trim()
  end

  defp expand_relative_links(dom, url) do
    dom
    |> Floki.parse()
    |> Floki.map(fn tuple -> expand_relative_link(tuple, url) end)
    |> Floki.raw_html()
  end

  defp expand_relative_link({"a", attributes}, url) do
    result_attributes =
      Enum.map(attributes, fn
        attr = {"href", "http" <> _rest} ->
          attr

        {"href", value} ->
          {"href", url <> value}

        attr ->
          attr
      end)

    {"a", result_attributes}
  end

  defp expand_relative_link({tag_name, attributes}, _), do: {tag_name, attributes}
end
