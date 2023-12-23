defmodule StoreWeb.Backoffice.DashboardLive.Index do
  use StoreWeb, :live_view

  alias Store.Accounts
  alias Store.Inventory
  alias Store.Utils

  import StoreWeb.Components.Pagination

  @impl true
  def mount(params, _session, socket) do
    {:ok, assign(socket, :orders, list_history(params) |> Enum.reverse())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :dashboard)
     |> assign(:params, params)
     |> assign(list_history(params))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end

  defp list_history(params) do
    case Inventory.list_displayable_orders_history(params, preloads: [:order, :admin]) do
      {:ok, {orders, meta}} ->
        %{orders: orders, meta: meta}

      {:error, flop} ->
        %{orders: [], meta: flop}
    end
  end
end
