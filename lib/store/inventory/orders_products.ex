defmodule Store.Inventory.Orders_Products do
  use Store.Schema
  alias Store.Repo
  alias Store.Accounts.QRCode
  alias Store.Accounts.User
  alias StoreWeb.Inventory.Product
  alias Store.Inventory.Order

  schema "orders_products" do
    belongs_to :order, Order
    belongs_to :product, Product
    timestamps()
  end

  @doc false
  def changeset(orders_products, attrs) do
    orders_products
    |> cast(attrs, [:order_id, :product_id])
    |> validate_required([:order_id, :product_id])
  end
end
