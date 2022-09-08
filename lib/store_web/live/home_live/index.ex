defmodule StoreWeb.HomeLive.Index do
  @moduledoc false
  use StoreWeb, :live_view

  alias Store.Inventory

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :home)
     |> assign(:product_types, list_product_types)}
  end

  defp list_product_types do
    Inventory.list_product_types()
  end

end
