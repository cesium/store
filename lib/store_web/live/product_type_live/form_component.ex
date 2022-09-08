defmodule StoreWeb.ProductTypeLive.FormComponent do
  use StoreWeb, :live_component

  alias Store.Inventory

  @impl true
  def update(%{product_type: product_type} = assigns, socket) do
    changeset = Inventory.change_product_type(product_type)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"product_type" => product_type_params}, socket) do
    changeset =
      socket.assigns.product_type
      |> Inventory.change_product_type(product_type_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"product_type" => product_type_params}, socket) do
    save_product_type(socket, socket.assigns.action, product_type_params)
  end

  defp save_product_type(socket, :edit, product_type_params) do
    case Inventory.update_product_type(socket.assigns.product_type, product_type_params) do
      {:ok, _product_type} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product type updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_product_type(socket, :new, product_type_params) do
    case Inventory.create_product_type(product_type_params) do
      {:ok, _product_type} ->
        {:noreply,
         socket
         |> put_flash(:info, "Product type created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
