defmodule StoreWeb.OrderLive.Index do
  use StoreWeb, :live_view

  alias Store.Inventory
  alias Store.Inventory.Order

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :orders, list_orders())}
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
  def handle_event("delete", %{"id" => id}, socket) do
    order = Inventory.get_order!(id)
    {:ok, _} = Inventory.delete_order(order)

<<<<<<< HEAD
    {:noreply, assign(socket, :orders, list_orders())}
=======
    order =
      Order
      |> where(status: :draft)
      |> where(user_id: ^current_user.id)
      |> Repo.one()

    order
    |> Order.changeset(%{status: :ordered})
    |> Repo.update!()

    {:noreply, socket}
>>>>>>> eed1c33 (add cart)
  end

  defp list_orders do
    Inventory.list_orders()
  end
end
