defmodule Store.InventoryFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Store.Inventory` context.
  """

  @doc """
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        pricepartner: 22,
        price: 42,
        stock: 100,
        max_per_user: 2
      })
      |> Store.Inventory.create_product()

    product
  end

  @doc """
  Generate a order.
  """
  def order_fixture(attrs \\ %{}) do
    {:ok, order} =
      attrs
      |> Enum.into(%{
        user_id: Ecto.UUID.generate(),
      })
      |> Store.Inventory.create_order()

    order
  end
end
