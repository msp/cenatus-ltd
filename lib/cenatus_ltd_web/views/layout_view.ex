defmodule CenatusLtdWeb.LayoutView do
  use CenatusLtdWeb, :view

  def og_title(conn) do
    cond do
      conn.assigns[:og_title] ->
        conn.assigns[:og_title]

      conn.assigns[:article] ->
        conn.assigns[:article].title

      conn.assigns[:articles] && length(conn.assigns[:articles]) > 0 ->
        Enum.at(conn.assigns[:articles], 0).title

      true ->
        default_title()
    end
  end

  def og_description(conn) do
    cond do
      conn.assigns[:og_description] ->
        conn.assigns[:og_description]

      conn.assigns[:article] ->
        conn.assigns[:article].summary

      conn.assigns[:articles] && length(conn.assigns[:articles]) > 0 ->
        Enum.at(conn.assigns[:articles], 0).summary

      true ->
        default_description()
    end
  end

  def og_image(conn) do
    image_url =
      cond do
        conn.assigns[:og_image] ->
          conn.assigns[:og_image]

        conn.assigns[:article] ->
          conn.assigns[:article].image_url

        conn.assigns[:articles] && length(conn.assigns[:articles]) > 0 ->
          Enum.at(conn.assigns[:articles], 0).image_url

        true ->
          ""
      end

    if image_url do
      case String.starts_with?(image_url, "https:") do
        true -> image_url
        false -> if String.length(image_url) > 0, do: "https:#{image_url}", else: image_url
      end
    else
      ""
    end
  end

  def og_url(conn) do
    Phoenix.Controller.current_url(conn)
  end

  def default_description do
    "Matt Spendlove is an artist from London who creates immersive installations, audiovisual performances and sonic artefacts. Across these situations he explores spatial ambiguity, structural form, waveform materiality and the illusory contours of psychophysics."
  end

  def default_title do
    "matt spendlove: art | music | sound design"
  end
end
