defmodule Store.Inventory.OrdersProducts do
  use Store.Schema
  alias StoreWeb.Inventory.Product
  alias Store.Inventory.Order

  schema "orders_products" do
    belongs_to :order, Order
    belongs_to :product, Product
    field :quantity, :integer, default: 1
    field :size, :string, default: "No Size"
    timestamps()
  end

  @doc false
  def changeset(orders_products, attrs) do
    orders_products
    |> cast(attrs, [:order_id, :product_id])
    |> validate_required([:order_id, :product_id])
  end
end
