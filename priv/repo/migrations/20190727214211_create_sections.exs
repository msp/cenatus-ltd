defmodule CenatusLtd.Repo.Migrations.CreateSections do
  use Ecto.Migration

  def change do
    create table(:sections) do
      add(:name, :string)

      timestamps()
    end

    create(index(:sections, [:name], unique: true))

    alter table(:articles) do
      add(:section_id, references(:sections))
    end
  end
end
