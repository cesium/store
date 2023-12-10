defmodule StoreWeb.ProductLive.Edit do
  @moduledoc false
  use StoreWeb, :live_view

  alias Store.Inventory

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    product = Inventory.get_product!(id, [])

    {:noreply,
     socket
     |> assign(:current_page, :products)
     |> assign(:page_title, "#{product.name}")
     |> assign(:product, Inventory.get_product!(id, []))
     |> assign(:current_user, socket.assigns[:current_user] || nil)}
  end
end
