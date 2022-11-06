defmodule StoreWeb.Backoffice.DashboardLive.Index do
  @moduledoc false
  use StoreWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :home)}
  end
end
