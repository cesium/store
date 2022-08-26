defmodule StoreWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias StoreWeb.Router.Helpers, as: Routes

  @conn StoreWeb.Endpoint

  def pages() do
    base_pages()
  end

  def role_pages(conn, user) do
    case user.role do
      :admin -> admin_pages(conn)
    end
  end

  defp base_pages do
    [
      %{
        key: :products,
        title: "Products",
        url: Routes.product_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :orders,
        title: "Orders",
        url: Routes.order_index_path(@conn, :index),
        tabs: []
      }
    ]
  end

  def admin_pages(_conn) do
    [
      %{
        key: :dashboard,
        title: "Dashboard",
        url: Routes.dashboard_index_path(@conn, :index),
        tabs: []
      }
    ]
  end
end
