defmodule Store.Repo.Seeds.Inventory do
  alias Store.Repo

  alias Store.Inventory.Product

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
            type: "saco"
          },
          %{
            name: "Caderno",
            description: "É um caderno",
            price: 200,
            type: "saco"
          },
          %{
            name: "Caneta",
            description: "É uma caneta",
            price: 200,
            type: "saco"
          }
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
