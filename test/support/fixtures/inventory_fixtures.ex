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
        type: "some type"
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
        redeemed: true
      })
      |> Store.Inventory.create_order()

    order
  end

  @doc """
  Generate a product_type.
  """
  def product_type_fixture(attrs \\ %{}) do
    {:ok, product_type} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> Store.Inventory.create_product_type()

    product_type
  end
end
