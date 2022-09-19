defmodule StoreWeb.ProductLive.Show do
  use StoreWeb, :live_view

  alias Store.Inventory
  alias Store.Uploaders
  alias Store.Inventory.Order
  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      Inventory.subscribe("purchased")
      Inventory.subscribe("updated")
      Inventory.subscribe("deleted")
    end

    {:ok, assign(socket, :id, id)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :products)
     |> assign(:product, Inventory.get_product!(id))}
  end

  def redeem_quantity(user_id, product_id) do
    order_quantity = Enum.count(Inventory.list_orders(where: [user_id: user_id]))

    quantity =
      case order_quantity do
        0 -> Inventory.get_product!(product_id).max_per_user
        _ -> Inventory.get_product!(product_id).max_per_user - order_quantity
      end

    if quantity < 0 do
      0
    else
      quantity
    end
  end

  @impl true
  def handle_event("delete", _payload, socket) do
    case Inventory.delete_product(socket.assigns.product) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:success, "Product deleted successfully!")
         |> push_redirect(to: Routes.product_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply,
         socket
         |> put_flash(:error, elem(changeset.errors[:orders], 0))
         |> assign(:changeset, changeset)}
    end
  end

  @impl true
  def handle_event("purchase", _payload, socket) do
    product = socket.assigns.product
    current_user = socket.assigns.current_user

    case Inventory.purchase(current_user, product) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:success, "Product purchased successfully!")
         |> reload()}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_info({event, _changes}, socket) when event in [:purchased, :updated] do
    {:noreply, reload(socket)}
  end

  def handle_info({event, _changes}, socket) when event in [:deleted] do
    {:noreply, push_redirect(socket, to: Routes.product_index_path(socket, :index))}
  end

  defp reload(socket) do
    id = socket.assigns.id

    socket
    |> assign(:current_page, :store)
    |> assign(:redeem_quantity, redeem_quantity(socket.assigns.current_user.id, id))
    |> assign(:product, Inventory.get_product!(id))
  end
end
