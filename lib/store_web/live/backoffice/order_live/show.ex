defmodule StoreWeb.Backoffice.OrderLive.Show do
  use StoreWeb, :live_view

  import Ecto.UUID
  import Ecto.Query
  import Store.Inventory
  alias Store.Repo
  alias Store.Inventory
  alias Store.Inventory.Order
  alias Store.Inventory.OrdersProducts
  alias Store.Uploaders
  alias Store.Accounts

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

    order
    |> Order.changeset(%{status: :paid})
    |> Repo.update!()

    {:noreply, socket}

  end


  @impl true
  def handle_event("delivered", _payload, socket) do
    order = socket.assigns.order

    order
    |> Order.changeset(%{status: :delivered})
    |> Repo.update!()

    {:noreply, socket}

  end

  defp user_email(id) do
    Accounts.get_user!(id).email
  end

  defp page_title(:show), do: "Show Order"
  defp page_title(:edit), do: "Edit Order"
end
