defmodule Store.Repo.Seeds.Orders do
  alias Store.Repo
  alias Store.Inventory.Order
  alias StoreWeb.Inventory.Product
  alias Store.Inventory
  alias Store.Accounts

  def run do
    seed_orders()
  end

  def seed_orders do
    case Repo.all(Order) do
      [] -> generate_orders(10)
        |> Enum.each(&insert_order/1)
      _ ->
        Mix.shell().error("Found orders, aborting seeding orders.")
  end
end

defp generate_orders(count) do
  users = Accounts.list_users()

  for _ <- 1..count do
    %{id: user_id} = Enum.random(users)
    %{
      user_id: user_id,
      status: Enum.random([:draft, :ordered, :paid]),
    }
  end
end

  defp insert_order(data) do
    %Order{}
    |> Order.changeset(data)
    |> Repo.insert!()
  end
end


Store.Repo.Seeds.Orders.run()
