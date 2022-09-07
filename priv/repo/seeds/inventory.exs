defmodule Store.Repo.Seeds.Inventory do
  alias Store.Repo

  alias StoreWeb.Inventory.Product

  def run do
    seed_products()
  end

  def seed_products do
    case Repo.all(Product) do
      [] ->
        [
          %{
            name: "Saco",
            description: "É um saco",
            price: 200,
            stock: 3,
            max_per_user: 1,
          },
          %{
            name: "Caderno",
            description: "É um caderno",
            price: 200,
            stock: 3,
            max_per_user: 1
          },
          %{
            name: "Caneta",
            description: "É uma caneta",
            price: 200,
            stock: 3,
            max_per_user: 1
          },
          %{
            name: "Lápis",
            description: "É um lápis",
            price: 200,
            stock: 3,
            max_per_user: 1
          },
        ]
        |> Enum.each(&insert_product/1)

      _ ->
        Mix.shell().error("Found products, aborting seeding products.")
    end
  end

  defp insert_product(data) do
    %Product{}
    |> Product.changeset(data)
    |> Repo.insert!()
  end
end

Store.Repo.Seeds.Inventory.run()
