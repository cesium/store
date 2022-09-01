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
        key: :home,
        title: "Novidades",
        emoji: "💡",
        url: Routes.home_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :products,
        title: "Roupa",
        emoji: "👕",
        url: Routes.product_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :products,
        title: "Acessórios",
        emoji: "⌚",
        url: Routes.product_index_path(@conn, :index),
        tabs: []
      },
      %{
        key: :products,
        title: "Papelaria",
        emoji: "📘",
        url: Routes.product_index_path(@conn, :index),
        tabs: []
      },
    ]
  end

  def admin_pages(conn) do
    [
      %{
        key: :dashboard,
        title: "Dashboard",
        url: Routes.dashboard_path(@conn, :index),
        tabs: []
      }
    ]
  end
end
