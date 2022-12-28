defmodule Store.Inventory.OrdersProducts do
  use Store.Schema
  alias StoreWeb.Inventory.Product
  alias Store.Inventory.Order

  @sizes ~w(extra_small small medium large extra_large extra_extra_large)a

  schema "orders_products" do
    belongs_to :order, Order
    belongs_to :product, Product
    field :quantity, :integer, default: 1
    field :size, Ecto.Enum, values: @sizes
    timestamps()
  end

  @doc false
  def changeset(orders_products, attrs) do
    orders_products
    |> cast(attrs, [:order_id, :product_id])
    |> validate_required([:order_id, :product_id])
  end
end
