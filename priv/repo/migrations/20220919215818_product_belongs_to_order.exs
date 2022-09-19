defmodule Store.Repo.Migrations.ProductBelongsToOrder do
  use Ecto.Migration

  def change do
    alter table(:products) do
      add :order_id, references(:orders, on_delete: :nothing, type: :binary_id)
    end
  end
end
