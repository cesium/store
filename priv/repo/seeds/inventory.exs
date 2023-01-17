defmodule Store.Repo.Seeds.Inventory do
  alias Store.Repo

  alias StoreWeb.Inventory.Product
  alias Store.Inventory.Stock
  def run do
    seed_products()
    seed_stock()
  end

  def seed_products do
    case Repo.all(Product) do
      [] ->
        [
          %{
            name: "Saco",
            description: "É um saco",
            price: 200,
            price_partnership: 100,
            stock: %Stock{
              xs_stock: 10,
              s_stock: 10,
              m_stock: 10,
              l_stock: 10,
              xl_stock: 10
            },
            max_per_user: 3
          },
          %{
            name: "Caderno",
            description: "É um caderno",
            price: 200,
            price_partnership: 100,
            stock: %Stock{
              xs_stock: 10,
              s_stock: 10,
              m_stock: 10,
              l_stock: 10,
              xl_stock: 10
            },
            max_per_user: 5
          },
          %{
            name: "Caneta",
            description: "É uma caneta",
            price: 200,
            price_partnership: 100,
            stock: %Stock{
              xs_stock: 10,
              s_stock: 10,
              m_stock: 10,
              l_stock: 10,
              xl_stock: 10
            },
            max_per_user: 3
          },
          %{
            name: "Lápis",
            description: "É um lápis",
            price: 200,
            price_partnership: 100,
            stock: %Stock{
              xs_stock: 10,
              s_stock: 10,
              m_stock: 10,
              l_stock: 10,
              xl_stock: 10
            },
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

  def seed_stock() do
    case Repo.all(Stock) do
      [] ->
        [
          %{
            xs_stock: 10,
            s_stock: 10,
            m_stock: 10,
            l_stock: 10,
            xl_stock: 10
          }
        ]
        |> Enum.each(&insert_stock/1)

      _ ->
        Mix.shell().error("Found stock, aborting seeding stock.")
    end
  end

  defp insert_stock(data) do
    product_id = Repo.get_by(Product, name: "Saco")
    data = Map.put(data, :product_id, product_id.id)
    %Stock{}
    |> Stock.changeset(data)
    |> Repo.insert!()
  end
end

Store.Repo.Seeds.Inventory.run()
