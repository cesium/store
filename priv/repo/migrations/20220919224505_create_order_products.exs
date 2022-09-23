defmodule Store.Repo.Migrations.OrdersAndProducts do
  use Ecto.Migration

  def change do
    create table(:order_products, primary_key: false) do
      add :order_id, references(:orders, on_delete: :nothing, type: :binary_id), primary_key: true
      add :product_id, references(:products, on_delete: :nothing, type: :binary_id), primary_key: true
      timestamps()
    end

    create index(:order_products, [:order_id])
    create index(:order_products, [:product_id])
  end
end
