defmodule StoreWeb.CartLive.Index do
  @moduledoc false
  use StoreWeb, :live_view
  import Ecto.Query
  import Store.Inventory
  alias Store.Repo
  alias Store.Inventory
  alias Store.Inventory.Order
  alias Store.Mailer
  alias StoreWeb.Emails.OrdersEmail

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
    {:ok, assign(socket, :orders, Inventory.list_orders() |> Repo.preload(:products))}
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

    order =
      Order
      |> where(status: :draft)
      |> where(user_id: ^current_user.id)
      |> Repo.one()

    order
    |> Order.changeset(%{status: :ordered})
    |> Repo.update!()

    OrdersEmail.ordered(order.id, to: current_user.email) |> Mailer.deliver()

    {:noreply, socket
    |> put_flash(:success, "Order update successfly")
    |> redirect(to: Routes.order_index_path(socket, :index))
    }
  end

  def handle_event("delete", %{"id" => id}, socket) do
    current_user = socket.assigns.current_user

    order =
      Order
      |> where(status: :draft)
      |> where(user_id: ^current_user.id)
      |> Repo.one()
      |> Repo.preload(:products)

    order_product =
      OrdersProducts
      |> where(order_id: ^order.id)
      |> where(product_id: ^id)
      |> Repo.one()


    Repo.delete!(order_product)

    {:noreply, socket}
  end
end
