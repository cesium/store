defmodule StoreWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias StoreWeb.Router.Helpers, as: Routes

  @conn StoreWeb.Endpoint

  def pages() do
    base_pages()
  end

  defp base_pages do
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
end
