defmodule Store.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :name, :string
      add :description, :text
      add :type, :string
      add :price, :integer

      timestamps()
    end
  end
end
