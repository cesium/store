defmodule Store.Inventory.OrdersProducts do
  use Store.Schema

  alias Store.Inventory.Product
  alias Store.Inventory.Order

  schema "orders_products" do
    field :quantity, :integer, default: 1
    field :size, Ecto.Enum, values: ~w(XS S M L XL XXL)a

    belongs_to :order, Order
    belongs_to :product, Product
    field :price, :integer

    timestamps()
  end

  @doc false
  def changeset(orders_products, attrs) do
    orders_products
    |> cast(attrs, [:order_id, :product_id, :quantity, :size, :price])
    |> validate_required([:order_id, :product_id, :quantity, :size, :price])
  end
end
