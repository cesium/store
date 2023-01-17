defmodule Store.Repo.Migrations.CreateStocks do
  use Ecto.Migration

  def change do
    create table(:stocks, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :xs_stock, :integer, default: 0
      add :s_stock, :integer, default: 0
      add :m_stock, :integer, default: 0
      add :l_stock, :integer, default: 0
      add :xl_stock, :integer, default: 0
      add :product_id, references(:products, on_delete: :delete_all, type: :binary_id)
      timestamps()
    end

    create unique_index(:stocks, [:product_id])
  end

end
