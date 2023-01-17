defmodule StoreWeb.Backoffice.StockLive.Edit do
  @moduledoc false
  use StoreWeb, :live_view

  alias Store.Inventory

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :product_stocks)
     |> assign(:page_title, "Edit Stock")
     |> assign(:stock, Inventory.get_stock!(id, []))}
  end
end
