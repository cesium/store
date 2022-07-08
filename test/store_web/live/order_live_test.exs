defmodule StoreWeb.OrderLiveTest do
  use StoreWeb.ConnCase

  import Phoenix.LiveViewTest
  import Store.InventoryFixtures

  @create_attrs %{redeemed: true}
  @update_attrs %{redeemed: false}
  @invalid_attrs %{redeemed: false}

  defp create_order(_) do
    order = order_fixture()
    %{order: order}
  end

  describe "Index" do
    setup [:create_order]

    test "lists all orders", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, Routes.order_index_path(conn, :index))

      assert html =~ "Listing Orders"
    end

    test "saves new order", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.order_index_path(conn, :index))

      assert index_live |> element("a", "New Order") |> render_click() =~
               "New Order"

      assert_patch(index_live, Routes.order_index_path(conn, :new))

      assert index_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#order-form", order: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.order_index_path(conn, :index))

      assert html =~ "Order created successfully"
    end

    test "updates order in listing", %{conn: conn, order: order} do
      {:ok, index_live, _html} = live(conn, Routes.order_index_path(conn, :index))

      assert index_live |> element("#order-#{order.id} a", "Edit") |> render_click() =~
               "Edit Order"

      assert_patch(index_live, Routes.order_index_path(conn, :edit, order))

      assert index_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#order-form", order: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.order_index_path(conn, :index))

      assert html =~ "Order updated successfully"
    end

    test "deletes order in listing", %{conn: conn, order: order} do
      {:ok, index_live, _html} = live(conn, Routes.order_index_path(conn, :index))

      assert index_live |> element("#order-#{order.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#order-#{order.id}")
    end
  end

  describe "Show" do
    setup [:create_order]

    test "displays order", %{conn: conn, order: order} do
      {:ok, _show_live, html} = live(conn, Routes.order_show_path(conn, :show, order))

      assert html =~ "Show Order"
    end

    test "updates order within modal", %{conn: conn, order: order} do
      {:ok, show_live, _html} = live(conn, Routes.order_show_path(conn, :show, order))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Order"

      assert_patch(show_live, Routes.order_show_path(conn, :edit, order))

      assert show_live
             |> form("#order-form", order: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#order-form", order: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.order_show_path(conn, :show, order))

      assert html =~ "Order updated successfully"
    end
  end
end
