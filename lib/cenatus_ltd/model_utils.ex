defmodule CenatusLtd.ModelUtils do
  use CenatusLtdWeb, :model

  def slugify(changeset, field) do
    if slug_field = get_change(changeset, field) do
      put_change(changeset, :slug, slug_from(slug_field))
    else
      changeset
    end
  end

  def slug_from(str) do
    str
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/, "-")
  end
end
