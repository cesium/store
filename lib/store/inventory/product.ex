defmodule Store.Inventory.Product do
  use Ecto.Schema
  import Ecto.Changeset

  schema "products" do
    field :description, :string
    field :name, :string
    field :price, :integer
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(product, attrs) do
    product
    |> cast(attrs, [:name, :description, :type, :price])
    |> validate_required([:name, :description, :type, :price])
  end
end
