defmodule Store.Inventory.Order do

  use Store.Schema
  alias Store.Accounts.QRCode
  alias Store.Accounts.User
  alias StoreWeb.Inventory.Product

  @required_fields ~w(user_id product_id)a

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
    has_many :product, Product
    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
