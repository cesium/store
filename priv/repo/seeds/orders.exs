defmodule Store.Repo.Seeds.Orders do
  alias Store.Repo
  alias Store.Inventory.Order

  def run do
    seed_orders()
  end

  def seed_orders do
    case Repo.all(Order) do
      [] ->
        [
          %{
            user_id: 1,
            product_id: 1,
            redeemed: false
          },
          %{
            user_id: 1,
            product_id: 2,
            redeemed: false
          },
          %{
            user_id: 1,
            product_id: 3,
            redeemed: false
          },
          %{
            user_id: 1,
            product_id: 4,
            redeemed: false
          },
          %{
            user_id: 2,
            product_id: 1,
            redeemed: false
          },
          %{
            user_id: 2,
            product_id: 2,
            redeemed: false
          },
          %{
            user_id: 2,
            product_id: 3,
            redeemed: false
          },
          %{
            user_id: 2,
            product_id: 4,
            redeemed: false
          },
          %{
            user_id: 3,
            product_id: 1,
            redeemed: false
          },
          %{
            user_id: 3,
            product_id: 2,
            redeemed: false
          },
          %{
            user_id: 3,
            product_id: 3,
            redeemed: false
          },
          %{
            user_id: 3,
            product_id: 4,
            redeemed: false
          },
          %{
            user_id: 4,
            product_id: 1,
            redeemed: false
          },
          %{
            user_id: 4,
            product_id: 2,
            redeemed: false
          },
          %{
            user_id: 4,
            product_id: 3,
            redeemed: false
          },
          %{
            user_id: 4,
            product_id: 4,
            redeemed: false
          },
          %{
            user_id: 5,
            product_id: 1,
            redeemed: false
          },
          %{
            user_id: 5,
            product_id: 2,
            redeemed: false
          },
          %{
            user_id: 5,
            product_id: 3,
            redeemed: false
          },
          %{
            user_id: 5,
            product_id: 4,
            redeemed: false
          }
        ]
        |> Enum.each(&insert_order/1)
      _ ->
        Mix.shell().error("Found orders, aborting seeding orders.")
  end
end

  defp insert_order(data) do
    %Order{}
    |> Order.changeset(data)
    |> Repo.insert!()
  end
end


Store.Repo.Seeds.Orders.run()
