defmodule StoreWeb.ProductTypeLive.Index do
  use StoreWeb, :live_view

  alias Store.Inventory
  alias Store.Inventory.ProductType

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :product_types, list_product_types())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Product type")
    |> assign(:product_type, Inventory.get_product_type!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Product type")
    |> assign(:product_type, %ProductType{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Product types")
    |> assign(:product_type, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    product_type = Inventory.get_product_type!(id)
    {:ok, _} = Inventory.delete_product_type(product_type)

    {:noreply, assign(socket, :product_types, list_product_types())}
  end

  defp list_product_types do
    Inventory.list_product_types()
  end
end
