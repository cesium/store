defmodule StoreWeb.Backoffice.OrderLive.Index do
  import Ecto.Query
  use StoreWeb, :live_view
  alias Store.Repo
  alias Store.Inventory
  alias Store.Inventory.Order
  alias Store.Uploaders
  alias Store.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :orders, Inventory.list_orders() |> Repo.preload(:products) |> Repo.preload(:user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :orders)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Order")
    |> assign(:order, Inventory.get_order!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Order")
    |> assign(:order, %Order{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end


  defp capitalize_status(status) do
    status
    |> Atom.to_string()
    |> String.capitalize()
  end

  defp total_price(order) do
    Enum.reduce(order.products, 0, fn product, acc -> acc + product.price end)
  end

  defp total_price2(order) do
    Enum.reduce(order.products, 0 , fn product , acc -> acc + product.price_partnership end)
  end

  defp discount(order) do
    total_price(order) - total_price2(order)
  end

  defp user_email(id) do
    Accounts.get_user!(id).email
  end
end