defmodule StoreWeb.CartLive.Index do
  @moduledoc false
  use StoreWeb, :live_view
  import Ecto.Query
  alias Store.Repo
  alias Store.Inventory
  alias Store.Inventory.Order
  alias Store.Inventory.OrdersProducts
  alias Store.Uploaders
  alias Store.Accounts


  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
    {:ok, assign(socket, :orders, Inventory.list_orders() |> Repo.preload(:products))}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :cart)}
  end

  @impl true
  def handle_event("checkout", _payload, socket) do
    current_user = socket.assigns.current_user

    order =
      Order
      |> where(status: :draft)
      |> where(user_id: ^current_user.id)
      |> Repo.one()

    order
    |> Order.changeset(%{status: :ordered})
    |> Repo.update!()

    {:noreply, socket}
  end

  defp test() do
    IO.puts("test")
  end

  defp total_price(order, id) do
    order =
        Order
        |> where(user_id: ^id)
        |> where(status: :draft)
        |> Repo.one()

    order =
      order
      |> Repo.preload(:products)

    if order do
      Enum.reduce(order.products, 0, fn product, acc ->
        acc + product.price
      end)
    else
      0
    end
  end

  defp total_price2(order, id) do
    order =
        Order
        |> where(user_id: ^id)
        |> where(status: :draft)
        |> Repo.one()

    order =
      order
      |> Repo.preload(:products)

    if order do
      Enum.reduce(order.products, 0, fn product, acc ->
        acc + product.price_partnership
      end)
    else
      0
    end
  end

  defp discount_price(order, id) do
    total_price(order, id) - total_price2(order, id)
  end
end
