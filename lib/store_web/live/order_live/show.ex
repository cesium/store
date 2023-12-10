defmodule StoreWeb.OrderLive.Show do
  use StoreWeb, :live_view

  alias Store.Accounts
  alias Store.Inventory
  alias Store.Uploaders
  alias Store.Utils

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    order = Inventory.get_order!(id, preloads: [:products])

    {:ok,
     socket
     |> assign(:order, order)
     |> assign(:user_email, Accounts.get_user_email(order.user_id))
     |> assign(:total_price, Inventory.total_price(order))
     |> assign(:inserted_at, NaiveDateTime.to_string(order.inserted_at))
     |> assign(:order_status, Utils.capitalize_status(order.status))}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :orders)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:order, Inventory.get_order!(id, preloads: [:products]))}
  end

  @impl true
  def handle_event("canceled", _payload, socket) do
    order = socket.assigns.order
    Inventory.update_order(order, %{status: :canceled})

    {:noreply,
     socket
     |> put_flash(:success, "Order canceled successfly.")
     |> redirect(to: Routes.order_index_path(socket, :index))}
  end

  defp page_title(:show), do: "Show Order"
  defp page_title(:edit), do: "Edit Order"
end
