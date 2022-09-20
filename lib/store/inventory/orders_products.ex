defmodule Store.Inventory.Orders_Products do

  use Store.Schema

  import Ecto.Query, warn: false
  alias Store.Repo
  alias Store.Accounts.QRCode
  alias Store.Accounts.User
  alias StoreWeb.Inventory.Product
  alias Store.Inventory.Order

  schema "orders_products" do
    belongs_to :order, Order
    belongs_to :product, Product
  end
end
