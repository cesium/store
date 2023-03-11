defmodule StoreWeb.OrderLive.Index do
  @moduledoc false
  import Ecto.Query
  use StoreWeb, :live_view
  alias Store.Repo
  import Store.Inventory, except: [list_displayable_user_orders: 2]
  alias Store.Inventory
  alias Store.Inventory.Order
  alias Store.Uploaders
  import StoreWeb.Components.Pagination

  @impl true
  def mount(params, _socket, socket) do
    {:ok, socket}
    {:ok, assign(socket, list_displayable_user_orders(params, socket.assigns.current_user))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :orders)
     |> assign(:params, params)
     |> assign(list_displayable_user_orders(params, socket.assigns.current_user))
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

  defp list_displayable_user_orders(params, user) do
    case Inventory.list_orders(params, preloads: [:products], where: [user_id: user.id]) do
      {:ok, {orders, meta}} ->
        %{orders: orders, meta: meta}

      {:error, flop} ->
        %{orders: [], meta: flop}
    end
  end

  defp draw_qr_code(order) do
    Routes.admin_order_show_path(StoreWeb.Endpoint, :show, order.id)
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#1F2937", width: 295, background_color: :transparent)
  end
end
