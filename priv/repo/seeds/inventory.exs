defmodule Store.Repo.Seeds.Inventory do
  alias Store.Repo

  alias Store.Inventory.Product

  def run do
    seed_products()
  end

  def seed_products do
    case Repo.all(Product) do
      [] ->
        for i <- 10..100 do

          %{
            name: "Product #{i}",
            description: "Product #{Enum.random(1..100)}",
            price: Enum.random(1000..10000),
            price_partnership: Enum.random(100..999),
            stock: Enum.random(100..1000),
            max_per_user: Enum.random(10..100),
            pre_order: Enum.random([true, false]),
            sizes: %{
              xs_size: Enum.random(10..100),
              s_size: Enum.random(10..100),
              m_size: Enum.random(10..100),
              l_size: Enum.random(10..100),
              xl_size: Enum.random(10..100),
              xxl_size: Enum.random(10..100),
            }
          }
        end
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
