defmodule Store.Repo.Migrations.OrdersAndProducts do
  use Ecto.Migration

  def change do
    create table(:order_products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :order_id, references(:orders, on_delete: :nothing, type: :binary_id)
      add :product_id, references(:products, on_delete: :nothing, type: :binary_id)
      timestamps()
    end

    create index(:order_products, [:order_id])
    create index(:order_products, [:product_id])
  end
end
