defmodule StoreWeb.ProductLive.Index do
  use StoreWeb, :live_view

  alias Store.Inventory
  alias Store.Uploaders
  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :products, list_products())}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :products)
     |> assign(:page_title, "CeSIUM Store - Products")}
  end

  defp list_products do
    Inventory.list_products()
  end
end
