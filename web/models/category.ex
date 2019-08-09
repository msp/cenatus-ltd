defmodule CenatusLtd.Category do
  use CenatusLtd.Web, :model

  @primary_key {:id, CenatusLtd.Permalink, autogenerate: true}
  schema "categories" do
    field(:name, :string)
    field(:slug, :string)

    has_many(:articles, CenatusLtd.Article)

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

  defimpl Phoenix.Param, for: CenatusLtd.Category do
    def to_param(%{slug: slug, id: id}) do
      "#{id}-#{slug}"
    end
  end
end
