defmodule Store.Inventory.Orders_Products do

  use Store.Schema
  import Ecto.Changeset
  alias Store.Repo
  alias Store.Accounts.QRCode
  alias Store.Accounts.User
  alias StoreWeb.Inventory.Product
  alias Store.Inventory.Order

  schema "order_products" do
    belongs_to :order, Order, type: :string
    belongs_to :product, Product
    timestamps()
  end

  @doc false
  def changeset(order_products, attrs) do
    order_products
    |> cast(attrs, [:order_id, :product_id])
    |> validate_required([:order_id, :product_id])
  end

  def products_changeset(order_products, attrs) do
    order_products
    |> Store.Repo.preload(:products)
    |> cast_assoc(:products)
    |> validate_required([:products])
  end


end
