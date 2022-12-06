defmodule StoreWeb.Backoffice.UserLive.Index do
  @moduledoc false
  use StoreWeb, :live_view
  alias Store.Repo
  alias Store.Inventory

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :orders, Inventory.list_orders() |> Repo.preload(:user))}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :cart)}
  end
end
