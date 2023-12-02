defmodule StoreWeb.CartLive.Index do
  @moduledoc false
  use StoreWeb, :live_view
  import Store.Inventory
  alias Store.Repo
  alias Store.Inventory.Order
  alias Store.Mailer
  alias StoreWeb.Emails.OrdersEmail

  @impl true
  def mount(_params, _session, socket) do
    order = list_user_draft_order(socket.assigns.current_user.id)

    {:ok,
     socket
     |> assign(:order, order)
     |> assign(:order_products, list_order_products(order.id))}
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

    order = get_order_draft_by_id(current_user.id, preloads: [])

    order
    |> update_order(%{status: :ordered})

    OrdersEmail.ordered(order.id, to: current_user.email) |> Mailer.deliver()

    {:noreply,
     socket
     |> put_flash(:success, "Order successfully created.")
     |> push_redirect(to: Routes.order_index_path(socket, :index))}
  end

  def handle_event("delete", %{"id" => id, "size" => size}, socket) do
    current_user = socket.assigns.current_user

    size = String.to_existing_atom(size)
    order = get_order_draft_by_id(current_user.id, preloads: [])
    order_product = get_order_product_by_ids(order.id, id, size)

    product = get_product!(order_product.product_id, preloads: [])
    update_stock(product, size, order_product.quantity)
    Repo.delete(order_product)

    {:noreply,
     socket
     |> put_flash(:info, "Product removed from cart successfully.")
     |> push_redirect(to: Routes.cart_index_path(socket, :index))}
  end
end
