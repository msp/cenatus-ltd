defmodule CenatusLtd.LoadAllTags do
  import Plug.Conn
  import Ecto.Query

  alias CenatusLtd.Tag
  alias CenatusLtd.Repo

  def init(default), do: default

  def call(conn, _default) do
    tags_query =
      from(tag in Tag,
        join: a in assoc(tag, :articles),
        group_by: [tag.name, tag.id],
        having: count(tag.id) >= 1,
        select: [tag]
      )

    tech_tags_query =
      from(tag in Tag,
        join: ta in assoc(tag, :tech_articles),
        group_by: [tag.name, tag.id],
        having: count(tag.id) >= 1,
        select: [tag]
      )

    tags = Enum.map(Repo.all(tags_query), fn res -> Enum.at(res, 0) end)

    tech_tags = Enum.map(Repo.all(tech_tags_query), fn res -> Enum.at(res, 0) end)

    conn = assign(conn, :tags, tags)
    assign(conn, :tech_tags, tech_tags)
  end
end
