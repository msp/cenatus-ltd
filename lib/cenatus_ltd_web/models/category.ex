defmodule CenatusLtdWeb.Category do
  use CenatusLtdWeb, :model

  @primary_key {:id, CenatusLtd.Permalink, autogenerate: true}
  schema "categories" do
    field(:name, :string)
    field(:slug, :string)

    has_many(:articles, CenatusLtdWeb.Article)

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

  defimpl Phoenix.Param, for: CenatusLtdWeb.Category do
    def to_param(%{slug: slug, id: id}) do
      "#{id}-#{slug}"
    end
  end
end
