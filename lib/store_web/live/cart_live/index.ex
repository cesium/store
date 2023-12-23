defmodule StoreWeb.CartLive.Index do
  @moduledoc false
  use StoreWeb, :live_view

  alias Store.Inventory
  alias StoreWeb.Emails.OrdersEmail

  @impl true
  def mount(_params, _session, socket) do
    user_id = socket.assigns.current_user.id
    order = Inventory.list_user_draft_order(user_id)

    order_products =
      case order do
        nil ->
          []

        _ ->
          Inventory.list_order_products(order.id)
      end

    {:ok, socket |> assign(:order, order) |> assign(:order_products, order_products)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :cart)}
  end

  @impl true
  def handle_event("checkout", _payload, socket) do
    current_user = socket.assigns.current_user

    order = Inventory.get_order_draft_by_id(current_user.id, preloads: [])

    Inventory.update_order(order, %{status: :ordered})

    OrdersEmail.ordered(order.id, to: current_user.email)

    {:noreply,
     socket
     |> put_flash(:success, "Order successfully created.")
     |> push_redirect(to: Routes.order_index_path(socket, :index))}
  end

  def handle_event("delete", %{"id" => id, "size" => size}, socket) do
    current_user = socket.assigns.current_user

    size = String.to_existing_atom(size)
    order = Inventory.get_order_draft_by_id(current_user.id, preloads: [])
    order_product = Inventory.get_order_product_by_ids(order.id, id, size)

    product = Inventory.get_product!(order_product.product_id, preloads: [])
    Inventory.update_stock(product, size, order_product.quantity)
    Inventory.delete_order_product(order_product)

    {:noreply,
     socket
     |> put_flash(:info, "Product removed from cart successfully.")
     |> push_redirect(to: Routes.cart_index_path(socket, :index))}
  end
end
