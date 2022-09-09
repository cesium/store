defmodule Store.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do

      add :id, :binary_id, primary_key: true

      add :name, :string
      add :description, :text
      add :price, :integer
      add :stock, :integer
      add :image, :string

      add :product_type_id, references(:product_types, on_delete: :nothing, type: :binary_id)

      timestamps()
    end

    create constraint(:products, :stock_must_be_positive, check: "stock >= 0")
  end
end
