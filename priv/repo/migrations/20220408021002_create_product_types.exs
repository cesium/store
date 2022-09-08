defmodule Store.Repo.Migrations.CreateProductTypes do
  use Ecto.Migration

  def change do
    create table(:product_types, primary_key: false) do
      add :id, :binary_id, primary_key: true

      add :name, :string

      timestamps()
    end
  end
end
