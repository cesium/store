defmodule Store.Inventory do
  @moduledoc """
  The Inventory context.
  """

  import Ecto.Query, warn: false
  alias Store.Repo
  alias Store.Inventory.Product
  use Store.Context

  @doc """
  Returns the list of products.

  ## Examples

      iex> list_products()
      [%Product{}, ...]

  """
  def list_products do
    Repo.all(Product)
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}, after_save \\ &{:ok, &1}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
    |> after_save(after_save)
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(
        %Product{} = product,
        attrs,
        after_save \\ &{:ok, &1}
      ) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
  end

  def update_product_image(%Product{} = product, attrs) do
    product
    |> Product.image_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  alias Store.Inventory.Order

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders do
    Repo.all(Order)
  end

  @doc """
  Gets a single order.

  Raises `Ecto.NoResultsError` if the Order does not exist.

  ## Examples

      iex> get_order!(123)
      %Order{}

      iex> get_order!(456)
      ** (Ecto.NoResultsError)

  """
  def get_order!(id), do: Repo.get!(Order, id)

  @doc """
  Creates a order.

  ## Examples

      iex> create_order(%{field: value})
      {:ok, %Order{}}

      iex> create_order(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_order(attrs \\ %{}) do
    %Order{}
    |> Order.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a order.

  ## Examples

      iex> update_order(order, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order(order, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order(%Order{} = order, attrs) do
    order
    |> Order.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a order.

  ## Examples

      iex> delete_order(order)
      {:ok, %Order{}}

      iex> delete_order(order)
      {:error, %Ecto.Changeset{}}

  """
  def delete_order(%Order{} = order) do
    Repo.delete(order)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking order changes.

  ## Examples

      iex> change_order(order)
      %Ecto.Changeset{data: %Order{}}

  """
  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
  end

  alias Store.Inventory.ProductType

  @doc """
  Returns the list of product_types.

  ## Examples

      iex> list_product_types()
      [%ProductType{}, ...]

  """
  def list_product_types do
    Repo.all(ProductType)
  end

  @doc """
  Gets a single product_type.

  Raises `Ecto.NoResultsError` if the Product type does not exist.

  ## Examples

      iex> get_product_type!(123)
      %ProductType{}

      iex> get_product_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_type!(id), do: Repo.get!(ProductType, id)

  @doc """
  Creates a product_type.

  ## Examples

      iex> create_product_type(%{field: value})
      {:ok, %ProductType{}}

      iex> create_product_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_type(attrs \\ %{}) do
    %ProductType{}
    |> ProductType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_type.

  ## Examples

      iex> update_product_type(product_type, %{field: new_value})
      {:ok, %ProductType{}}

      iex> update_product_type(product_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_type(%ProductType{} = product_type, attrs) do
    product_type
    |> ProductType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_type.

  ## Examples

      iex> delete_product_type(product_type)
      {:ok, %ProductType{}}

      iex> delete_product_type(product_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_type(%ProductType{} = product_type) do
    Repo.delete(product_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_type changes.

  ## Examples

      iex> change_product_type(product_type)
      %Ecto.Changeset{data: %ProductType{}}

  """
  def change_product_type(%ProductType{} = product_type, attrs \\ %{}) do
    ProductType.changeset(product_type, attrs)
  end
end
