defmodule Store.Repo.Migrations.AddQrcodeTable do
  use Ecto.Migration

  def change do
    create table(:qrcodes, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :uuid, :binary
      add :order_id, references(:orders, on_delete: :delete_all, type: :binary_id)
      timestamps()
    end
  end
end
