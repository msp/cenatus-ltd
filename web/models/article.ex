defmodule CenatusLtd.Article do
  use CenatusLtd.Web, :model

  alias CenatusLtd.Tag
  alias CenatusLtd.Repo

  @primary_key {:id, CenatusLtd.Permalink, autogenerate: true}
  schema "articles" do
    field(:title, :string)
    field(:summary, :string)
    field(:content, :string)
    field(:image_url, :string)
    field(:published_at, Ecto.DateTime)
    field(:slug, :string)

    belongs_to(:section, CenatusLtd.Section)

    many_to_many(:tags, CenatusLtd.Tag,
      join_through: "article_tags",
      on_delete: :delete_all,
      on_replace: :delete
    )

    many_to_many(:tech_tags, CenatusLtd.Tag,
      join_through: "article_tech_tags",
      on_delete: :delete_all,
      on_replace: :delete
    )

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    tags_list = params["tags"] || params[:tags] || ""
    tech_tags_list = params["tech_tags"] || params[:tech_tags] || ""

    struct
    |> cast(params, [:title, :summary, :content, :image_url, :published_at])
    |> CenatusLtd.ModelUtils.slugify(:title)
    |> put_assoc(:tags, parse_tags_from(tags_list) |> Enum.map(&get_or_insert_tag/1))
    |> put_assoc(:tech_tags, parse_tags_from(tech_tags_list) |> Enum.map(&get_or_insert_tag/1))
    |> validate_required([:title, :summary, :content, :published_at])
  end

  def parse_tags_from(tags_list) do
    tags_list
    |> String.split(",")
    |> Enum.map(&String.trim/1)
    |> Enum.map(&String.downcase/1)
    |> Enum.uniq()
    |> Enum.reject(&(&1 == ""))
  end

  defp get_or_insert_tag(name) do
    Repo.get_by(CenatusLtd.Tag, name: name) || Repo.insert!(Tag.changeset(%Tag{}, %{name: name}))
  end

  defimpl Phoenix.Param, for: CenatusLtd.Article do
    def to_param(%{slug: slug, id: id}) do
      "#{id}-#{slug}"
    end
  end
end
