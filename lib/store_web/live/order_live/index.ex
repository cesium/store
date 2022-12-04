defmodule StoreWeb.OrderLive.Index do
  @moduledoc false
  import Ecto.Query
  use StoreWeb, :live_view
  alias Store.Repo
  import Store.Inventory
  alias Store.Inventory
  alias Store.Inventory.Order
  alias Store.Inventory.OrdersProducts
  alias Store.Uploaders
  alias Store.Accounts

  @impl true
  def mount(_params, _socket, socket) do
    {:ok, socket}
    {:ok, assign(socket, :orders, Inventory.list_orders() |> Repo.preload(:products))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :orders)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Order")
    |> assign(:order, Inventory.get_order!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Order")
    |> assign(:order, %Order{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Orders")
    |> assign(:order, nil)
  end

  @impl true
  def handle_event("checkout", _payload, socket) do
    current_user = socket.assigns.current_user

    order =
      Order
      |> where(status: :draft)
      |> where(user_id: ^current_user.id)
      |> Repo.one()

    order
    |> Order.changeset(%{status: :ordered})
    |> Repo.update!()

    {:noreply, socket}
  end

  defp draw_qr_code(order) do
    Routes.admin_order_show_path(StoreWeb.Endpoint, :show, order.id)
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#1F2937", width: 295, background_color: :transparent)
  end

  @impl true
  def handle_event("draft", _payload, socket) do
    order = socket.assigns.order
    Inventory.update_status(order, %{status: :draft})
    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel", _payload, socket) do
    order = socket.assigns.order
    Inventory.delete_order(order)
    {:noreply, socket}
  end
end
