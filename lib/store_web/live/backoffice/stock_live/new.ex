defmodule StoreWeb.Backoffice.StockLive.New do
  @moduledoc false
  use StoreWeb, :live_view
  alias Store.Inventory.Stock

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :store)
     |> assign(:page_title, "New Stock")
     |> assign(:product, %Stock{})}
  end
end
