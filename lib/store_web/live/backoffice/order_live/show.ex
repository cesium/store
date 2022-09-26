defmodule StoreWeb.Backoffice.OrderLive.Show do
  import Ecto.Query
  use StoreWeb, :live_view
  alias Store.Repo
  alias Store.Inventory
  alias Store.Inventory.Order
  alias Store.Uploaders

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :orders)
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:order, Inventory.get_order!(id) |> Repo.preload(:user) |> Repo.preload(:products))}
  end


  def handle_event("paid", _payload, socket) do
    order = socket.assigns.order
    IO.inspect(order)
    order
    |> Order.changeset(%{status: :paid})
    |> Repo.update!()

    redirect(socket, to: Routes.home_index_path(socket, :index))
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


  defp page_title(:show), do: "Show Order"
  defp page_title(:edit), do: "Edit Order"
end
