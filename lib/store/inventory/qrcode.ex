defmodule Store.Inventory.QRCode do
  @moduledoc """
  A qrcode found in the orders page for each order
  """

  use Store.Schema
  alias Store.Inventory.Order
  @required_fields ~w(uuid)a

  schema "qrcodes" do
    field :uuid, :binary_id
    belongs_to :order, Order
    timestamps()
  end

  @doc false
  def changeset(qr_code, attrs) do
    qr_code
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end
