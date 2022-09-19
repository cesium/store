defmodule Store.Repo.Migrations.CreateOrders do
  use Ecto.Migration

  def change do
    create table(:orders, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :redeemed, :boolean, default: false
      timestamps()
    end
  end
end
