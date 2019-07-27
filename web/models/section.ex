defmodule CenatusLtd.Section do
  use CenatusLtd.Web, :model

  schema "sections" do
    field(:name, :string)
    has_many(:articles, CenatusLtd.Article)

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name])
    |> validate_required([:name])
  end
end
