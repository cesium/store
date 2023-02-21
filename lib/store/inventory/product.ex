defmodule StoreWeb.Inventory.Product do
  @moduledoc """
  A product.
  """
  use Store.Schema
  alias Store.Inventory.Order
  alias Store.Uploaders

  @required_fields ~w(name description
                      price price_partnership stock max_per_user pre_order)a

  @optional_fields []

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :integer
    field :price_partnership, :integer
    field :stock, :integer
    field :max_per_user, :integer
    field :image, Uploaders.ProductImage.Type
    field :pre_order, :boolean, default: false
    many_to_many :order, Order, join_through: Store.Inventory.OrdersProducts
    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> cast_attachments(attrs, [:image])
    |> validate_required(@required_fields)
    |> unique_constraint(:name)
  end

  def image_changeset(product, attrs) do
    product
    |> cast_attachments(attrs, [:image])
  end
end
