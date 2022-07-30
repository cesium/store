defmodule Store.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :type, :string
      add :price, :integer
      timestamps()
    end

  create constraint(:products, :stock_must_be_positive, check: "stock >= 0")

  end
end
