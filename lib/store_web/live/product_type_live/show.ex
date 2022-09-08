defmodule StoreWeb.ProductTypeLive.Show do
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
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:product_type, Inventory.get_product_type!(id))}
  end

  defp page_title(:show), do: "Show Product type"
  defp page_title(:edit), do: "Edit Product type"
end
