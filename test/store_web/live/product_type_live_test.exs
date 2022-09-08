defmodule StoreWeb.ProductTypeLiveTest do
  use StoreWeb.ConnCase

  import Phoenix.LiveViewTest
  import Store.InventoryFixtures

  @create_attrs %{name: "some name"}
  @update_attrs %{name: "some updated name"}
  @invalid_attrs %{name: nil}

  defp create_product_type(_) do
    product_type = product_type_fixture()
    %{product_type: product_type}
  end

  describe "Index" do
    setup [:create_product_type]

    test "lists all product_types", %{conn: conn, product_type: product_type} do
      {:ok, _index_live, html} = live(conn, Routes.product_type_index_path(conn, :index))

      assert html =~ "Listing Product types"
      assert html =~ product_type.name
    end

    test "saves new product_type", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.product_type_index_path(conn, :index))

      assert index_live |> element("a", "New Product type") |> render_click() =~
               "New Product type"

      assert_patch(index_live, Routes.product_type_index_path(conn, :new))

      assert index_live
             |> form("#product_type-form", product_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#product_type-form", product_type: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_type_index_path(conn, :index))

      assert html =~ "Product type created successfully"
      assert html =~ "some name"
    end

    test "updates product_type in listing", %{conn: conn, product_type: product_type} do
      {:ok, index_live, _html} = live(conn, Routes.product_type_index_path(conn, :index))

      assert index_live |> element("#product_type-#{product_type.id} a", "Edit") |> render_click() =~
               "Edit Product type"

      assert_patch(index_live, Routes.product_type_index_path(conn, :edit, product_type))

      assert index_live
             |> form("#product_type-form", product_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#product_type-form", product_type: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_type_index_path(conn, :index))

      assert html =~ "Product type updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes product_type in listing", %{conn: conn, product_type: product_type} do
      {:ok, index_live, _html} = live(conn, Routes.product_type_index_path(conn, :index))

      assert index_live |> element("#product_type-#{product_type.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#product_type-#{product_type.id}")
    end
  end

  describe "Show" do
    setup [:create_product_type]

    test "displays product_type", %{conn: conn, product_type: product_type} do
      {:ok, _show_live, html} = live(conn, Routes.product_type_show_path(conn, :show, product_type))

      assert html =~ "Show Product type"
      assert html =~ product_type.name
    end

    test "updates product_type within modal", %{conn: conn, product_type: product_type} do
      {:ok, show_live, _html} = live(conn, Routes.product_type_show_path(conn, :show, product_type))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Product type"

      assert_patch(show_live, Routes.product_type_show_path(conn, :edit, product_type))

      assert show_live
             |> form("#product_type-form", product_type: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#product_type-form", product_type: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.product_type_show_path(conn, :show, product_type))

      assert html =~ "Product type updated successfully"
      assert html =~ "some updated name"
    end
  end
end
