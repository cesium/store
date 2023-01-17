defmodule Store.Repo.Migrations.CreateProducts do
  use Ecto.Migration

  def change do
    create table(:products, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string
      add :description, :text
      add :price, :integer
      add :price_partnership, :integer
      add :max_per_user, :integer
      add :image, :string
      add :pre_order, :boolean, default: false
      timestamps()
    end

    create constraint(:products, :partners_price_highlow_then_price, if_not_exists: true,
             check: "price >= price_partnership"
           )
  end
end
