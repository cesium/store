defmodule StoreWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias StoreWeb.Router.Helpers, as: Routes

  @conn StoreWeb.Endpoint

  def user_pages do
    [
      %{
        key: :home,
        title: "Home",
        url: Routes.home_index_path(@conn, :index),
        tabs: []
      },
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

  def admin_pages do
    [
      %{
        key: :home,
        title: "Home",
        url: Routes.home_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :dashboard,
        title: "Dashboard",
        url: Routes.admin_dashboard_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :products,
        title: "Products",
        url: Routes.product_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :orders,
        title: "Orders",
        url: Routes.admin_order_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :users,
        title: "Users",
        url: Routes.admin_user_index_path(@conn, :index)
      }
    ]
  end

  def guest_pages do
    [
      %{
        key: :home,
        title: "Home",
        url: Routes.home_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :products,
        title: "Products",
        url: Routes.product_index_path(@conn, :index),
        tabs: []
      }
    ]
  end
end
