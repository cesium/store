defmodule StoreWeb.OrderLive.Show do
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
     |> assign(:current_page, :orders)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:order, Inventory.get_order!(id))
     |> assign(:qrcode, qr_code(socket, id))}
  end

  defp page_title(:show), do: "Show Order"
  defp page_title(:edit), do: "Edit Order"

  defp qr_code(socket, id) do
    Routes.admin_order_edit_url(socket, :edit, id)
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#1F2937", width: 295, background_color: :transparent)
  end
end
