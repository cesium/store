defmodule StoreWeb.ProductLiveTest do
  use StoreWeb.ConnCase
  import Ecto
  import Phoenix.LiveViewTest
  import Store.InventoryFixtures

  @create_attrs %{
    description: "some description",
    name: "some name",
    price: 42,
    stock: 100,
    max_per_user: 2
  }

  @update_attrs %{
    description: "some updated description",
    name: "some updated name",
    price: 43,
    type: "some updated type"
  }

  @invalid_attrs %{description: nil, name: nil, price: nil, type: nil}

  defp create_product(_) do
    product = product_fixture()
    %{product: product}
  end
end
