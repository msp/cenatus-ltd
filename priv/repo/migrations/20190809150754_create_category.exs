defmodule CenatusLtd.Repo.Migrations.CreateCategory do
  use Ecto.Migration

  def change do
    create table(:categories) do
      add(:name, :string)

      timestamps()
    end

    create(index(:categories, [:name], unique: true))

    alter table(:articles) do
      add(:category_id, references(:categories))
    end
  end
end
