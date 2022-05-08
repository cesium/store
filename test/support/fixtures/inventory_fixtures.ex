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
  Generate a product.
  """
  def product_fixture(attrs \\ %{}) do
    {:ok, product} =
      attrs
      |> Enum.into(%{
        description: "some description",
        name: "some name",
        price: 42,
        type: "some type"
      })
      |> Store.Inventory.create_product()

    product
  end
end
