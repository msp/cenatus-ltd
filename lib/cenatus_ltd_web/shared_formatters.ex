defmodule CenatusLtdWeb.SharedFormatters do
  def as_html(txt) do
      txt
      |> Earmark.as_html!
      |> Phoenix.HTML.raw
  end

  def formatted(datetime) do
    Timex.format!(datetime, "%d %b %Y", :strftime)
  end

  def linkify(text) do
    Regex.replace(
      ~r{(https?://[^\s<]+)},
      Phoenix.HTML.html_escape(text) |> Phoenix.HTML.safe_to_string(),
      fn _, url ->
        domain = URI.parse(url).host || url
        "<a href=\"#{url}\" target=\"_blank\">#{domain}</a>"
      end
    )
  end
end