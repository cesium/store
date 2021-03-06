defmodule Store.InventoryTest do
  use Store.DataCase

  alias Store.Inventory

  describe "products" do
    alias Store.Inventory.Product

    import Store.InventoryFixtures

    @invalid_attrs %{description: nil, name: nil, price: nil, type: nil}

    test "list_products/0 returns all products" do
      product = product_fixture()
      assert Inventory.list_products() == [product]
    end

    test "get_product!/1 returns the product with given id" do
      product = product_fixture()
      assert Inventory.get_product!(product.id) == product
    end

    test "create_product/1 with valid data creates a product" do
      valid_attrs = %{
        description: "some description",
        name: "some name",
        price: 42,
        type: "some type"
      }

      assert {:ok, %Product{} = product} = Inventory.create_product(valid_attrs)
      assert product.description == "some description"
      assert product.name == "some name"
      assert product.price == 42
      assert product.type == "some type"
    end

    test "create_product/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_product(@invalid_attrs)
    end

    test "update_product/2 with valid data updates the product" do
      product = product_fixture()

      update_attrs = %{
        description: "some updated description",
        name: "some updated name",
        price: 43,
        type: "some updated type"
      }

      assert {:ok, %Product{} = product} = Inventory.update_product(product, update_attrs)
      assert product.description == "some updated description"
      assert product.name == "some updated name"
      assert product.price == 43
      assert product.type == "some updated type"
    end

    test "update_product/2 with invalid data returns error changeset" do
      product = product_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_product(product, @invalid_attrs)
      assert product == Inventory.get_product!(product.id)
    end

    test "delete_product/1 deletes the product" do
      product = product_fixture()
      assert {:ok, %Product{}} = Inventory.delete_product(product)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_product!(product.id) end
    end

    test "change_product/1 returns a product changeset" do
      product = product_fixture()
      assert %Ecto.Changeset{} = Inventory.change_product(product)
    end
  end

  describe "orders" do
    alias Store.Inventory.Order

    import Store.InventoryFixtures

    @invalid_attrs %{redeemed: nil}

    test "list_orders/0 returns all orders" do
      order = order_fixture()
      assert Inventory.list_orders() == [order]
    end

    test "get_order!/1 returns the order with given id" do
      order = order_fixture()
      assert Inventory.get_order!(order.id) == order
    end

    test "create_order/1 with valid data creates a order" do
      valid_attrs = %{redeemed: true}

      assert {:ok, %Order{} = order} = Inventory.create_order(valid_attrs)
      assert order.redeemed == true
    end

    test "create_order/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Inventory.create_order(@invalid_attrs)
    end

    test "update_order/2 with valid data updates the order" do
      order = order_fixture()
      update_attrs = %{redeemed: false}

      assert {:ok, %Order{} = order} = Inventory.update_order(order, update_attrs)
      assert order.redeemed == false
    end

    test "update_order/2 with invalid data returns error changeset" do
      order = order_fixture()
      assert {:error, %Ecto.Changeset{}} = Inventory.update_order(order, @invalid_attrs)
      assert order == Inventory.get_order!(order.id)
    end

    test "delete_order/1 deletes the order" do
      order = order_fixture()
      assert {:ok, %Order{}} = Inventory.delete_order(order)
      assert_raise Ecto.NoResultsError, fn -> Inventory.get_order!(order.id) end
    end

    test "change_order/1 returns a order changeset" do
      order = order_fixture()
      assert %Ecto.Changeset{} = Inventory.change_order(order)
    end
  end
end
