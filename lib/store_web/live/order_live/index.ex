defmodule StoreWeb.OrderLive.Index do
  use StoreWeb, :live_view

  import StoreWeb.Components.Pagination

  alias Store.Inventory
  alias Store.Inventory.Order
  alias Store.Uploaders
  alias Store.Utils

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

  @impl true
  def handle_event("checkout", _payload, socket) do
    current_user = socket.assigns.current_user

    Inventory.list_user_draft_order(current_user.id)
    |> Inventory.update_order(%{status: :ordered})

    {:noreply, socket}
  end

  defp list_displayable_user_orders(params, user) do
    case Inventory.list_displayable_orders(params,
           preloads: [:products],
           where: [user_id: user.id]
         ) do
      {:ok, {orders, meta}} ->
        %{orders: orders, meta: meta}

      {:error, flop} ->
        %{orders: [], meta: flop}
    end
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Order")
    |> assign(:order, Inventory.get_order!(id, preloads: []))
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
end
