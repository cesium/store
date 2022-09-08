defmodule Store.Inventory.ProductType do
  @moduledoc """
  A type of product.
  """
  use Store.Schema

  alias Store.Inventory.Product

  schema "product_types" do
    field :name, :string

    has_many :products, Product

    timestamps()
  end

  @doc false
  def changeset(product_type, attrs) do
    product_type
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
