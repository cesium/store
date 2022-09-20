defmodule Store.Inventory.Order do

  use Store.Schema

  import Ecto.Query, warn: false
  alias Store.Repo
  alias Store.Accounts.QRCode
  alias Store.Accounts.User
  alias StoreWeb.Inventory.Product

 @required_fields ~w(user_id)a
  @optional_fields [
    :redeemed
  ]

  @derive {
    Flop.Schema,
    filterable: [],
    sortable: [],
    compound_fields: [search: []]
  }

  schema "orders" do
    field :redeemed, :boolean, default: false
    belongs_to :user , Accounts.User
    many_to_many :products, Product,
      join_through: "orders_products"
    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @optional_fields)
    |> validate_required(@required_fields)
  end
end
