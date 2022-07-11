defmodule Store.Inventory.Order do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(user_id product_id)a

  @optional_fields [
    :redeemed
  ]

  schema "orders" do
    field :redeemed, :boolean, default: false

    has_many: :products, Product

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, [:redeemed])
    |> validate_required([:redeemed])
  end
end
