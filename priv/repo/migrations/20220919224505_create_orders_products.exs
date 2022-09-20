defmodule Store.Repo.Migrations.OrdersAndProducts do
  use Ecto.Migration

  def change do
    create table(:orders_products, primary_key: false) do
      add :order_id, references(:orders, on_delete: :delete_all, type: :binary_id)
      add :product_id, references(:products, on_delete: :delete_all, type: :binary_id)
      timestamps()
    end

    create index(:orders_products, [:order_id])
    create index(:orders_products, [:product_id])

    create unique_index(
      :orders_products,
      [:order_id, :product_id],
      name: :orders_products_order_product_unique
    )

    create unique_index(
      :orders_products,
      [:order_id, :product_id],
      name: :orders_products_order_id_product_id_index
    )
  end
end
