defmodule StoreWeb.Config do
  @moduledoc """
  Web configuration for our pages.
  """
  alias StoreWeb.Router.Helpers, as: Routes

  @conn StoreWeb.Endpoint

  def pages(conn) do
    base_pages()
  end

  defp base_pages do
    [
      %{
        key: :products,
        title: "Products",
        url: Routes.product_index_path(@conn, :index),
        tabs: []
      },
    ]
  end

end
