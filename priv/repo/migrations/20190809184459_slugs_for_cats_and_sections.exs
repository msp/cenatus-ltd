defmodule CenatusLtd.Repo.Migrations.SlugsForCatsAndSections do
  use Ecto.Migration

  def change do
    alter table(:sections) do
      add(:slug, :string)
    end

    create(index(:sections, [:slug], unique: true))

    alter table(:categories) do
      add(:slug, :string)
    end

    create(index(:categories, [:slug], unique: true))
  end
end
