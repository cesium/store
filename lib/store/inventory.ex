defmodule Store.Inventory do
  @moduledoc """
  The Inventory context.
  """

  use Store.Context
  import Ecto.Changeset
  alias Ecto.Multi
  alias StoreWeb.Accounts.User
  alias StoreWeb.Inventory.Product
  alias Store.Inventory.Order
  alias Store.Inventory.Orders_Products

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
  def update_product(%Product{} = product, attrs, after_save \\ &{:ok, &1}) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
    |> after_save(after_save)
  end


  @doc """
  Updates a product image

  ## Examples
        iex> update_product_image(product, %{field: new_value})
        {:ok, %Product{}}

        iex> update_product_image(product, %{field: bad_value})
        {:error, %Ecto.Changeset{}}

  """
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
    product
    |> Ecto.Changeset.change()
    |> Ecto.Changeset.foreign_key_constraint(:orders,
      name: :orders_product_id_fkey,
      message: "cannot delete product because it has orders"
    )
    |> Repo.delete()
    |> broadcast(:deleted)
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
  def list_orders(params \\ %{}) do
    Order
    |> Repo.all()
  end


  alias Store.Inventory.Orders_Products
  @doc """
  Returns the list of orders_products.
    iex> list_orders_products()
    [%Orders_Products{}, ...]
  """
  def list_orders_products(params \\ %{}) do
    Orders_Products
    |> Repo.all()
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
  Creates an order_product relationship.

  ## Examples

    iex> create_order_product(%{field: value})
    {:ok, %Orders_Products{}}

    iex> create_order_product(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

  """
  def create_order_product(attrs) do
    %Orders_Products{}
    |> Orders_Products.changeset(attrs)
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

  @doc """
    Returns a function that can be used to broadcast the given event.

    iex> subscribe(topic)
    {:ok, #PID<0.0.0>}

  """
  def subscribe(topic) when topic in ["purchased", "updated", "deleted"] do
    Phoenix.PubSub.subscribe(Store.PubSub, topic)
  end

  @doc """
    Function that is used to purchase a product.

  ## Examples
    iex> purchase(user, product)
    {:ok, %Order{}}

    iex> purchase(user, product)
    {:error, %Ecto.Changeset{}}
  """

  def purchase(user, product) do
    order =
      Order
      |> where(user_id: ^user.id)
      |> where(status: :draft)
      |> Repo.one()
      |> Repo.preload([:user, :products])

    if order do
      create_order_product(%{order_id: order.id, product_id: product.id})
    else
      {:ok, order} = create_order(%{user_id: user.id})
      create_order_product(%{order_id: order.id, product_id: product.id})
    end
  end

  @doc """
    Function which verifies that the user has 1 or more of each product in his cart.
    ## Examples
     iex> redeem_quantity(user)
     {:ok, %Order{}}

     iex> redeem_quantity(user)
     {:error, %Ecto.Changeset{}}

    """

  def redeem_quantity(order_id, product_id) do
    order_quantity = Enum.count(Inventory.list_orders(where: [id: order_id]))

    quantity =
      case order_quantity do
        0 -> Inventory.get_product!(product_id).max_per_user
        _ -> Inventory.get_product!(product_id).max_per_user - order_quantity
      end

    if quantity < 0 do
      {:error, "You must buy at least one product"}
    else
      quantity
    end
  end

  defp broadcast({:error, _reason} = error, _event), do: error

  defp broadcast({:ok, %Product{} = product}, event)
       when event in [:purchased] do
    Phoenix.PubSub.broadcast!(Store.PubSub, "purchased", {event, product.stock})
    {:ok, product}
  end

  defp broadcast({:ok, %Product{} = product}, event)
       when event in [:updated] do
    Phoenix.PubSub.broadcast!(Store.PubSub, "updated", {event, product})
    {:ok, product}
  end

  defp broadcast({:ok, %Product{} = product}, event)
       when event in [:deleted] do
    Phoenix.PubSub.broadcast!(Store.PubSub, "deleted", {event, product})
    {:ok, product}
  end
end
