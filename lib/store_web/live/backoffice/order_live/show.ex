defmodule StoreWeb.Backoffice.OrderLive.Show do
  use StoreWeb, :live_view

  import Store.Inventory
  alias Store.Repo
  alias Store.Inventory
  alias Store.Uploaders
  alias Store.Accounts
  alias StoreWeb.Emails.OrdersEmail
  alias Store.Mailer

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

  @impl true
  def handle_event("paid", _payload, socket) do
    order = socket.assigns.order
    admin = socket.assigns.current_user
    Inventory.update_status(order, %{status: :paid, admin_id: admin.id})

    user = Accounts.get_user!(order.user_id)
    OrdersEmail.paid(order.id, to: user.email) |> Mailer.deliver()

    {:noreply,
     socket
     |> redirect(to: Routes.admin_order_index_path(socket, :index))}
  end

  @impl true
  def handle_event("delivered", _payload, socket) do
    order = socket.assigns.order
    admin = socket.assigns.current_user
    Inventory.change_status(order, %{status: :delivered, admin_id: admin.id})

    user = Accounts.get_user!(order.user_id)
    OrdersEmail.delivered(order.id, to: user.email) |> Mailer.deliver()

    {:noreply,
     socket
     |> redirect(to: Routes.admin_order_index_path(socket, :index))}
  end

  def handle_event("ready", _payload, socket) do
    order = socket.assigns.order
    admin = socket.assigns.current_user
    Inventory.change_status(order, %{status: :ready, admin_id: admin.id})

    user = Accounts.get_user!(order.user_id)
    OrdersEmail.ready(order.id, to: user.email) |> Mailer.deliver()

    {:noreply,
     socket
     |> redirect(to: Routes.admin_order_index_path(socket, :index))}
  end

  defp user_email(id) do
    Accounts.get_user!(id).email
  end

  defp page_title(:show), do: "Show Order"
  defp page_title(:edit), do: "Edit Order"
end
