defmodule CenatusLtdWeb.SharedFormatters do
  def as_html(txt) do
      txt
      |> Earmark.as_html!
      |> Phoenix.HTML.raw
  end

  def formatted(datetime) do
    Timex.format!(datetime, "%d %b %Y", :strftime)
  end
end