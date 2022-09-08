defmodule Store.Repo.Seeds.Inventory do
  alias Store.Repo

  alias Store.Inventory.Product
  alias Store.Inventory.ProductType

  def run do
    seed_types()
    seed_products()
  end

  def seed_types() do
    case Repo.all(ProductType) do
      [] ->
        %ProductType{}
        |> ProductType.changeset(%{
          name: "Stationery"
        })
        |> Repo.insert!()

        %ProductType{}
        |> ProductType.changeset(%{
          name: "Jacket"
        })
        |> Repo.insert!()

        %ProductType{}
        |> ProductType.changeset(%{
          name: "Hoodie"
        })
        |> Repo.insert!()

        %ProductType{}
        |> ProductType.changeset(%{
          name: "T-Shirt"
        })
        |> Repo.insert!()

        %ProductType{}
        |> ProductType.changeset(%{
          name: "Stickers"
        })
        |> Repo.insert!()

        %ProductType{}
        |> ProductType.changeset(%{
          name: "Accessories"
        })
        |> Repo.insert!()

      _ ->
        Mix.shell().error("Found product types, aborting seeding product types.")
    end
  end


  def seed_products do

    product_types = Repo.all(ProductType)

    case Repo.all(Product) do
      [] ->
        [
          %{
            name: "Saco",
            description: "É um saco",
            price: 200,
            stock: 3,
            product_type_id: Enum.random(product_types).id
          },
          %{
            name: "Caderno",
            description: "É um caderno",
            price: 200,
            stock: 3,
            product_type_id: Enum.random(product_types).id
          },
          %{
            name: "Caneta",
            description: "É uma caneta",
            price: 200,
            stock: 3,
            product_type_id: Enum.random(product_types).id
          },
          %{
            name: "Lápis",
            description: "É um lápis",
            price: 200,
            stock: 3,
            product_type_id: Enum.random(product_types).id
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
