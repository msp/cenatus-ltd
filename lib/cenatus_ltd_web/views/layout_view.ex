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

    case String.starts_with?(image_url, "https:") do
      true -> image_url
      false -> if String.length(image_url) > 0, do: "https:#{image_url}", else: image_url
    end
  end

  def og_url(conn) do
    Phoenix.Controller.current_url(conn)
  end

  def default_description do
    "Cenatus operates in the fields of creative production and software design for live events, sound art installations, online media projects and immersive experiences.

    We promote new music and media, develop artists and enable wider public use of innovative digital technologies for creativity.

    Cenatus produced Netaudio London, the UK’s foremost digital culture festival incorporating strands for Live Music, Sound Art, Conference and Broadcast that operated in 2006, 2008 and 2011."
  end

  def default_title do
    "Cenatus: creative | technology | production"
  end
end
