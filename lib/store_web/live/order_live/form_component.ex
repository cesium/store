defmodule StoreWeb.OrderLive.FormComponent do
  use StoreWeb, :live_component

  alias Store.Inventory

  @impl true
  def update(%{order: order} = assigns, socket) do
    changeset = Inventory.change_order(order)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"order" => order_params}, socket) do
    changeset =
      socket.assigns.order
      |> Inventory.change_order(order_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"order" => order_params}, socket) do
    save_order(socket, socket.assigns.action, order_params)
  end

  defp save_order(socket, :edit, order_params) do
    case Inventory.update_order(socket.assigns.order, order_params) do
      {:ok, _order} ->
        {:noreply,
         socket
         |> put_flash(:info, "Order updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_order(socket, :new, order_params) do
    case Inventory.create_order(order_params) do
      {:ok, _order} ->
        {:noreply,
         socket
         |> put_flash(:info, "Order created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
