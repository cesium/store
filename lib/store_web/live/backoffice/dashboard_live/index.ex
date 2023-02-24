defmodule StoreWeb.Backoffice.DashboardLive.Index do
  use StoreWeb, :live_view
  import Store.Inventory
  alias Store.Repo
  alias Store.Inventory
  alias Store.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     assign(socket, :orders, Inventory.list_orders_history() |> Repo.preload([:order, :admin]))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :dashboard)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end

  defp user_email(id) do
    if id == nil do
      nil
    else
      Accounts.get_user!(id).email
    end
  end
end
