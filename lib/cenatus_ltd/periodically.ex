defmodule CenatusLtd.Periodically do
  use GenServer

  require Logger

  import SweetXml

  @feeds [
    "https://mattspendlove.substack.com/feed",
    "https://deepassignmentsldn.substack.com/feed"
  ]

  @notes_url "https://substack.com/api/v1/reader/feed/profile/80838772?limit=10&types=note"

  ############################## Client ########################################
  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def init(state) do
    schedule_work()

    {:ok,
     Map.merge(state, %{recent_posts: get_recent_posts(), recent_tracks: get_recent_tracks()})}
  end

  def posts do
    try do
      GenServer.call(__MODULE__, :get_recent_posts, 2000)
    catch
      :exit, _ ->
        Logger.warning("get_recent_posts exited abnormally")
        []
    end
  end

  def tracks do
    try do
      GenServer.call(__MODULE__, :get_recent_tracks, 2000)
    catch
      :exit, _ ->
        Logger.warning("get_recent_tracks exited abnormally")
        []
    end
  end

  ############################## Server ########################################
  def handle_call(:get_recent_posts, _from, state) do
    {:reply, state[:recent_posts], state}
  end

  def handle_call(:get_recent_tracks, _from, state) do
    {:reply, state[:recent_tracks], state}
  end

  def handle_info(:work, state) do
    schedule_work()

    {:noreply,
     Map.merge(state, %{recent_posts: get_recent_posts(), recent_tracks: get_recent_tracks()})}
  end

  ############################## Private #######################################
  defp schedule_work() do
    Process.send_after(self(), :work, 1 * 60 * 1000)
  end

  defp get_recent_posts do
    rss_posts = Enum.flat_map(@feeds, &fetch_feed/1)
    notes = fetch_notes()

    (rss_posts ++ notes)
    |> Enum.sort_by(& &1.date, {:desc, NaiveDateTime})
    |> Enum.take(6)
  end

  defp fetch_feed(url) do
    case HTTPoison.get(url, [], follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse_feed(body)

      {:ok, %HTTPoison.Response{status_code: status}} ->
        Logger.warning("Feed #{url} returned status #{status}")
        []

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.warning("Error fetching feed #{url}: #{inspect(reason)}")
        []
    end
  rescue
    e ->
      Logger.warning("Exception fetching feed #{url}: #{inspect(e)}")
      []
  end

  defp parse_feed(xml) do
    xml
    |> xpath(~x"//item"l,
      title: ~x"./title/text()"s,
      link: ~x"./link/text()"s,
      pub_date: ~x"./pubDate/text()"s,
      description: ~x"./description/text()"s
    )
    |> Enum.map(fn item ->
      %{
        type: :article,
        title: item.title,
        link: item.link,
        date: parse_date(item.pub_date),
        description: item.description
      }
    end)
    |> Enum.reject(&is_nil(&1.date))
  end

  defp fetch_notes do
    case HTTPoison.get(@notes_url, [], follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        CenatusLtd.SubstackNotes.parse_response(body)

      {:ok, %HTTPoison.Response{status_code: status}} ->
        Logger.warning("Notes API returned status #{status}")
        []

      {:error, %HTTPoison.Error{reason: reason}} ->
        Logger.warning("Error fetching notes: #{inspect(reason)}")
        []
    end
  rescue
    e ->
      Logger.warning("Exception fetching notes: #{inspect(e)}")
      []
  end

  defp parse_date(date_string) do
    case Timex.parse(date_string, "{RFC1123}") do
      {:ok, datetime} -> NaiveDateTime.truncate(Timex.to_naive_datetime(datetime), :second)
      _ -> nil
    end
  end

  defp get_recent_tracks() do
    user = "polymorphic"
    args = [limit: 15, page: 1, extended_info: 0]

    try do
      case Elixirfm.User.recent_tracks(user, args) do
        {:ok, tracks} ->
          Logger.info("Got tracks")
          tracks

        {:error, error} ->
          Logger.warning("Error getting tracks: #{inspect(error)}")
          nil

        {:error, message, error} ->
          Logger.warning("Error getting tracks: #{message} #{inspect(error)}")
          nil
      end
    rescue
      re in Elixirfm.RequestError ->
        Logger.warning("Connection error getting latest tracks: #{inspect(re)}")
        nil
    end
  end
end
