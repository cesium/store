defmodule Store.Inventory.OrderHistory do
  use Store.Schema

  alias Store.Accounts.User
  alias Store.Inventory.Order

  @required_fields ~w(admin_id status order_id)a
  @status ~w(draft ordered ready paid canceled delivered)a

  @derive {
    Flop.Schema,
    filterable: [:status], sortable: [:updated_at], default_limit: 5
  }

  schema "orders_history" do
    field :status, Ecto.Enum, values: @status, default: :draft

    belongs_to :admin, User
    belongs_to :order, Order

    timestamps()
  end

  @doc false
  def changeset(order_history, attrs) do
    order_history
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
