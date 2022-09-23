defmodule StoreWeb.Inventory.Product do
  @moduledoc """
  A product.
  """
  use Store.Schema
  alias Store.Inventory.Order
  alias Store.Uploaders

  @required_fields ~w(name description
                      price stock max_per_user)a

  @optional_fields []

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [:name],
    compound_fields: [search: [:name]],
    default_order: %{
      order_by: [:name],
      order_directions: [:asc]
    }
  }

  schema "products" do
    field :name, :string
    field :description, :string
    field :price, :integer
    field :stock, :integer
    field :max_per_user, :integer
    field :image, Uploaders.ProductImage.Type
    many_to_many :order, Order, join_through: Store.Inventory.Orders_Products
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

  def stock_changeset(product, attrs) do
    product
    |> cast_assoc(attrs, [:stock])
    |> validate_required([:stock])
    |> validate_number(:stock, greater_than_or_equal_to: 0)
  end

  def image_changeset(product, attrs) do
    product
    |> cast_attachments(attrs, [:image])
  end
end
