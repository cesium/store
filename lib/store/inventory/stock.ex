defmodule Store.Inventory.Stock do

  use Store.Schema
  alias StoreWeb.Inventory.Product

  @required_fields ~w(product_id)a
  @optional_fields ~w(xs_stock s_stock m_stock l_stock xl_stock)a

  schema "stocks" do
    field :xs_stock, :integer
    field :s_stock, :integer
    field :m_stock, :integer
    field :l_stock, :integer
    field :xl_stock, :integer
    belongs_to :product, Product
    timestamps()
  end

  @doc false
  def changeset(stocks, attrs) do
    stocks
    |> cast(attrs, @required_fields ++ @optional_fields)
    |> validate_required(@required_fields)
  end
end
