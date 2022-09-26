defmodule StoreWeb.Backoffice.DashboardLive.Index do
  @moduledoc false
  use StoreWeb, :live_view
  alias Store.Inventory
  alias Store.Repo

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :orders, Inventory.list_orders() |> Repo.preload(:products) |> Repo.preload(:user))}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :home)}
  end

  defp capitalize_status(status) do
    status
    |> Atom.to_string()
    |> String.capitalize()
  end

  defp total_price(order) do
    Enum.reduce(order.products, 0, fn product, acc -> acc + product.price end)
  end
end
