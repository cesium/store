defmodule Store.Inventory.Order do
  use Ecto.Schema
  import Ecto.Changeset

  schema "orders" do
    field :redeemed, :boolean, default: false

    has_many :products, Product

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:redeemed])
    |> validate_required([:redeemed])
  end
end
