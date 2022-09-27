defmodule StoreWeb.Backoffice.OrderLive.Show do
  use StoreWeb, :live_view

  import Ecto.UUID
  import Ecto.Query
  alias Store.Repo
  alias Store.Inventory
  alias Store.Inventory.Order
  alias Store.Inventory.OrdersProducts
  alias Store.Uploaders
  alias Store.Accounts

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok, assign(socket, order: Inventory.get_order!(id))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :orders)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:order, Inventory.get_order!(id) |> Repo.preload(:products))}
  end



  defp capitalize_status(status) do
    status
    |> Atom.to_string()
    |> String.capitalize()
  end

  defp total_price(order) do
    Enum.reduce(order.products, 0, fn product, acc -> acc + product.price end)
  end

  defp draw_qr_code(order) do
    order.id
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#1F2937", width: 295, background_color: :transparent)
  end

  defp user_email(id) do
    Accounts.get_user!(id).email
  end

  defp page_title(:show), do: "Show Order"
  defp page_title(:edit), do: "Edit Order"
end
