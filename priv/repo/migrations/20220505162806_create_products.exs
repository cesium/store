defmodule Store.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :price, :integer
      add :price_partnership, :integer
      add :stock, :integer
      add :max_per_user, :integer
      add :image, :string
      timestamps()
    end

    create constraint(:products, :stock_must_be_positive, check: "stock >= 0")

    create constraint(:products, :partners_price_highlow_then_price,
             check: "price >= pricepartner"
           )
  end
end
