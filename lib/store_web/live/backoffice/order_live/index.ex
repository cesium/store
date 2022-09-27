defmodule StoreWeb.Backoffice.OrderLive.Index do
  import Ecto.UUID
  import Ecto.Query
  use StoreWeb, :live_view
  alias Store.Repo
  alias Store.Inventory
  alias Store.Inventory.Order
  alias Store.Inventory.OrdersProducts
  alias Store.Uploaders
  alias Store.Accounts

  @impl true
  def mount(_params, _session, socket) do
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

    redirect(socket, to: Routes.order_path(socket, :index))
    {:noreply, socket}
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
end
