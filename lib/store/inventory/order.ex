defmodule Store.Inventory.Order do
  use Store.Schema

  alias Store.Accounts.User
  alias Store.Inventory.Product
  alias Store.Inventory.OrdersProducts

  @required_fields ~w(user_id)a
  @optional_fields ~w(status)a
  @status ~w(draft ordered ready paid canceled delivered)a

  @derive {
    Flop.Schema,
    filterable: [:status], sortable: [:updated_at], default_limit: 5
  }

  schema "orders" do
    field :status, Ecto.Enum, values: @status, default: :draft

    belongs_to :user, User
    many_to_many :products, Product, join_through: OrdersProducts

    timestamps()
  end

  @doc false
  def changeset(order, attrs) do
    order
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
