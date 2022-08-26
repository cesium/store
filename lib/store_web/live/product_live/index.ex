defmodule StoreWeb.ProductLive.Index do
  use StoreWeb, :live_view

  alias Store.Inventory
  alias StoreWeb.Inventory.Product

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :products, list_products())}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :products)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product = Inventory.get_product!(id)
    {:ok, _} = Inventory.delete_product(product)

    {:noreply, assign(socket, :products, list_products())}
  end

  defp list_products do
    Inventory.list_products()
  end
end
