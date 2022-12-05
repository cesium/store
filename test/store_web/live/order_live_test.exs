defmodule StoreWeb.OrderLiveTest do
  use StoreWeb.ConnCase

  import Phoenix.LiveViewTest
  import Store.InventoryFixtures

  defp create_order(_) do
    order = order_fixture()
    %{order: order}
  end

  describe "Index" do
    setup [:register_and_log_in_user, :create_order]

    test "lists all orders", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.order_index_path(conn, :index))

      assert html =~ "Listing Orders"
    end
  end
end
