defmodule Store.Inventory.Order do
  use Store.Schema

  alias Store.Repo
  alias Store.Accounts.QRCode
  alias Store.Accounts.User
  alias StoreWeb.Inventory.Product

  @required_fields ~w(user_id)a
  @optional_fields ~w(status)a
  @status ~w(draft ordered paid canceled delivered)a

  @derive {
    Flop.Schema,
    filterable: [], sortable: [], compound_fields: [search: []]
  }

  schema "orders" do
    field :redeemed, :boolean, default: false
    belongs_to :user, User
    field :status, Ecto.Enum, values: @status, default: :draft
    many_to_many :products, Product, join_through: Store.Inventory.OrdersProducts
    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
