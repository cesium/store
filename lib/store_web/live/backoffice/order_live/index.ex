defmodule StoreWeb.Backoffice.OrderLive.Index do
  use StoreWeb, :live_view

  import StoreWeb.Components.Pagination

  alias Store.Accounts
  alias Store.Inventory
  alias Store.Inventory.Order
  alias Store.Uploaders
  alias Store.Utils

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, list_orders(params))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :orders)
     |> assign(:params, params)
     |> assign(list_orders(params))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Order")
    |> assign(:order, Inventory.get_order!(id, preloads: []))
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

  defp list_orders(params) do
    case Inventory.list_orders(params, preloads: [:products, :user]) do
      {:ok, {orders, meta}} ->
        %{orders: orders, meta: meta}

      {:error, flop} ->
        %{orders: [], meta: flop}
    end
  end
end
