defmodule CenatusLtd.Tag do
  use CenatusLtd.Web, :model

  @primary_key {:id, CenatusLtd.Permalink, autogenerate: true}
  schema "tags" do
    field(:name, :string)
    field(:slug, :string)

    many_to_many(:articles, CenatusLtd.Article,
      join_through: "article_tags",
      on_delete: :delete_all,
      on_replace: :delete
    )

    many_to_many(:tech_articles, CenatusLtd.Article,
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
    struct
    |> cast(params, [:name])
    |> CenatusLtd.ModelUtils.slugify(:name)
    |> validate_required([:name])
  end

  defimpl Phoenix.Param, for: CenatusLtd.Tag do
    def to_param(%{slug: slug, id: id}) do
      "#{id}-#{slug}"
    end
  end
end
