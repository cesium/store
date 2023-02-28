defmodule StoreWeb.ProductLive.FormComponent do
  @moduledoc false
  use StoreWeb, :live_component

  import Store.Inventory
  alias Store.Uploaders

  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:id, id)}
  end

  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:product, get_product!(id, preloads: :order))
     |> assign(:current_page, :products)}
  end

  @impl true
  def update(%{product: product} = assigns, socket) do
    changeset = change_product(product)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"product" => product_params}, socket) do
    product = socket.assigns.product
    user = socket.assigns.user

    case purchase(user, product, product_params) do
      {:ok, _product} ->
        {:noreply,
         socket
         |> put_flash(:success, "Product purchased successfully!")
         |> push_redirect(to: Routes.cart_index_path(socket, :index))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
