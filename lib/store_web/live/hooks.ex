defmodule StoreWeb.Hooks do
  @moduledoc """
  Ensures common `assigns` are applied to all LiveViews attaching this hook.
  """
  import Phoenix.LiveView

  alias Parzival.Accounts

  def on_mount(:default, _params, _session, socket) do
    {:cont, assign(socket, :page_title, "Cesium Store")}
  end

  def on_mount(:current_user, _params, _session, socket) do
    {:cont, socket}
  end
end
