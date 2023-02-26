defmodule StoreWeb.Backoffice.UserLive.Index do
  @moduledoc false
  use StoreWeb, :live_view
  alias Store.Accounts

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :users, Accounts.list_users())}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply,
     socket
     |> assign(:current_page, :users)}
  end
end
