defmodule CenatusLtd.SubstackNotes do
  @moduledoc """
  Parses Substack Notes from the undocumented profile feed API.
  Designed to fail gracefully — returns [] on any unexpected input.
  """

  require Logger

  def parse_response(json) when is_binary(json) do
    case Jason.decode(json) do
      {:ok, parsed} -> parse_json(parsed)
      _ ->
        Logger.warning("SubstackNotes: invalid JSON")
        []
    end
  rescue
    e ->
      Logger.warning("SubstackNotes: exception decoding JSON: #{inspect(e)}")
      []
  end

  def parse_response(_), do: []

  def parse_json(%{"items" => items}) when is_list(items) do
    items
    |> Enum.filter(&match?(%{"comment" => %{"body" => _}}, &1))
    |> Enum.map(&parse_item/1)
    |> Enum.reject(&is_nil/1)
  end

  def parse_json(_) do
    Logger.warning("SubstackNotes: unexpected JSON structure")
    []
  end

  def parse_item(%{"comment" => comment}) do
    with body when is_binary(body) <- comment["body"],
         date_str when is_binary(date_str) <- comment["date"],
         id when not is_nil(id) <- comment["id"],
         handle when is_binary(handle) <- comment["handle"] do
      case parse_iso_date(date_str) do
        nil -> nil
        date ->
          %{
            type: :note,
            title: String.trim(body),
            title_html: CenatusLtdWeb.SharedFormatters.linkify(String.trim(body)),
            link: "https://substack.com/@#{handle}/note/c-#{id}",
            date: date,
            description: nil
          }
      end
    else
      _ -> nil
    end
  end

  def parse_item(_), do: nil

  def parse_iso_date(date_string) when is_binary(date_string) do
    case Timex.parse(date_string, "{ISO:Extended}") do
      {:ok, datetime} -> NaiveDateTime.truncate(Timex.to_naive_datetime(datetime), :second)
      _ -> nil
    end
  end

  def parse_iso_date(_), do: nil
end
