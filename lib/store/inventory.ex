defmodule Store.Inventory do
  @moduledoc """
  The Inventory context.
  """
  use Store.Context

  alias Store.Accounts.User
  alias Store.Inventory.Product
  alias Store.Inventory.Order
  alias Store.Inventory.OrderHistory
  alias Store.Inventory.OrdersProducts
  alias Store.Inventory

  # PRODUCTS

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
  def get_product!(id, opts) when is_list(opts) do
    Product
    |> apply_filters(opts)
    |> Repo.get!(id)
  end

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
  def update_product(%Product{} = product, attrs \\ %{}, after_save \\ &{:ok, &1}) do
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

  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
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

  def list_orders(params \\ %{})

  @doc """
  Returns the list of orders.

  ## Examples

      iex> list_orders()
      [%Order{}, ...]

  """
  def list_orders(opts) when is_list(opts) do
    Order
    |> apply_filters(opts)
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def list_orders(flop) do
    Flop.validate_and_run(Order, flop, for: Order)
  end

  def list_orders(%{} = flop, opts) when is_list(opts) do
    Order
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Order)
  end

  def list_displayable_orders(%{} = flop, opts) when is_list(opts) do
    Order
    |> status_filter([:ordered, :ready, :paid, :delivered])
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: Order)
  end

  def list_user_draft_order(user_id) do
    Order
    |> where(user_id: ^user_id)
    |> where(status: :draft)
    |> Repo.one()
  end

  defp status_filter(q, status), do: where(q, [o], o.status in ^status)

  @doc """
  Returns the list of orders_products.
    iex> list_orders_products()
    [%OrdersProducts{}, ...]
  """
  def list_orders_products() do
    OrdersProducts
    |> Repo.all()
  end

  def list_order_products(order_id) do
    OrdersProducts
    |> where(order_id: ^order_id)
    |> preload([:product])
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
  def get_order!(id, opts) when is_list(opts) do
    Order
    |> apply_filters(opts)
    |> Repo.get!(id)
  end

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
    {:ok, %OrdersProducts{}}

    iex> create_order_product(%{field: bad_value})
    {:error, %Ecto.Changeset{}}

  """
  def create_order_product(attrs) do
    %OrdersProducts{}
    |> OrdersProducts.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates an order_product.

  ## Examples

      iex> update_order_product(order_product, %{field: new_value})
      {:ok, %Order{}}

      iex> update_order_product(order_product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_order_product(%OrdersProducts{} = orders_product, attrs) do
    orders_product
    |> OrdersProducts.changeset(attrs)
    |> Repo.update()
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

  def change_order(%Order{} = order, attrs \\ %{}) do
    Order.changeset(order, attrs)
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

  def purchase(%User{} = user, %Product{} = product, product_params) do
    order = get_order_draft_by_id(user.id, preloads: [])

    case order do
      %Order{} ->
        handle_existing_order(order, product, product_params, user.partnership)

      nil ->
        handle_new_order(user, product, product_params)
    end
  end

  defp handle_existing_order(order, product, product_params, partnership) do
    quantity = String.to_integer(product_params["quantity"])

    order_products =
      OrdersProducts
      |> where(order_id: ^order.id, product_id: ^product.id)
      |> Repo.all()

    total_quantity_user =
      Enum.reduce(order_products, 0, fn order_product, acc -> acc + order_product.quantity end)

    if total_quantity_user + quantity > product.max_per_user do
      {:error, "The maximum quantity for this product per user is #{product.max_per_user}."}
    else
      size_found =
        Enum.any?(order_products, fn order_product ->
          order_product.size == String.to_existing_atom(product_params["size"])
        end)

      price =
        case partnership do
          true -> product.price_partnership
          false -> product.price
        end

      if size_found do
        update_order_products(order_products, price, product_params, quantity)
      else
        add_product_to_order(order, product, price, product_params)
      end

      {:ok, product}
    end
  end

  defp update_order_products(order_products, price, product_params, quantity) do
    Enum.each(order_products, fn order_product ->
      if order_product.size == String.to_existing_atom(product_params["size"]) do
        update_order_product(order_product, %{
          quantity: order_product.quantity + quantity,
          price: order_product.price + price * quantity
        })
      end
    end)
  end

  defp handle_new_order(%User{} = user, %Product{} = product, product_params) do
    {:ok, order} = create_order(%{user_id: user.id})

    price =
      case user.partnership do
        true -> product.price_partnership
        false -> product.price
      end

    add_product_to_order(order, product, price, product_params)
  end

  def add_product_to_order(%Order{} = order, %Product{} = product, price, product_params) do
    quantity = String.to_integer(product_params["quantity"])
    size = product_params["size"]

    if update_stock_sizes(product, size, quantity) == {:error, "Not enough stock."} do
      {:error, "Not enough stock."}
    else
      create_order_product(%{
        order_id: order.id,
        product_id: product.id,
        quantity: quantity,
        size: size,
        price: price * quantity
      })
    end
  end

  def update_stock_sizes(product, "XS", quantity), do: update_stock(product, :xs_size, quantity)
  def update_stock_sizes(product, "S", quantity), do: update_stock(product, :s_size, quantity)
  def update_stock_sizes(product, "M", quantity), do: update_stock(product, :m_size, quantity)
  def update_stock_sizes(product, "L", quantity), do: update_stock(product, :l_size, quantity)
  def update_stock_sizes(product, "XL", quantity), do: update_stock(product, :xl_size, quantity)
  def update_stock_sizes(product, "XXL", quantity), do: update_stock(product, :xxl_size, quantity)

  def update_stock(product, size_key, quantity) do
    updated_sizes =
      product.sizes
      |> Map.update(size_key, 0, &(&1 - quantity))

    product_stock =
      updated_sizes
      |> Map.values()
      |> Enum.filter(&is_number(&1))
      |> Enum.sum()

    size_stock = Map.get(updated_sizes, size_key)

    if size_stock < 0 do
      {:error, "Not enough stock."}
    else
      transformed_sizes =
        Map.from_struct(updated_sizes)
        |> Map.drop([:id])

      update_product_stock_sizes(product, transformed_sizes, product_stock)
    end
  end

  def update_product_stock_sizes(product, updated_sizes, product_stock) do
    product
    |> Product.changeset(%{stock: product_stock, sizes: updated_sizes})
    |> Repo.update!()

    {:ok, "Product added to cart"}
  end

  @doc """
  Function which verifies that the user has 1 or more of each product in his cart.
  ## Examples
   iex> redeem_quantity(user)
   {:ok, %Order{}}

   iex> redeem_quantity(user)
   {:error, %Ecto.Changeset{}}

  """

  def redeem_quantity(product_id) do
    order_quantity = Enum.count(list_orders(preloads: []))

    quantity =
      case order_quantity do
        0 -> Inventory.get_product!(product_id, []).max_per_user
        _ -> Inventory.get_product!(product_id, []).max_per_user - order_quantity
      end

    if quantity < 0 do
      {:error, "You must buy at least one product."}
    else
      quantity
    end
  end

  def total_price(order) do
    Enum.reduce(order.products, 0, fn product, acc -> acc + product.price end)
  end

  def total_price_with_partnership(order) do
    Enum.reduce(order.products, 0, fn product, acc -> acc + product.price_partnership end)
  end

  def discount(order) do
    total_price(order) - total_price_with_partnership(order)
  end

  def total_price_cart(order_products) do
    Enum.reduce(order_products, 0, fn order_product, acc ->
      acc + order_product.price
    end)
  end

  def total_price_partnership_cart(id) do
    order =
      Order
      |> where(user_id: ^id)
      |> where(status: :draft)
      |> Repo.one()

    order =
      order
      |> Repo.preload(:products)

    if order do
      Enum.reduce(order.products, 0, fn product, acc ->
        acc + product.price_partnership
      end)
    else
      0
    end
  end

  def change_status(order, status) do
    order
    |> Order.changeset(status)
    |> Repo.update()
  end

  def discount_cart(id, order_products) do
    total_price_cart(order_products) - total_price_partnership_cart(id)
  end

  def create_orders_history(order) do
    %OrderHistory{}
    |> OrderHistory.changeset(order)
    |> Repo.insert()
  end

  def list_orders_history(params \\ %{})

  def list_orders_history(opts) when is_list(opts) do
    OrderHistory
    |> apply_filters(opts)
    |> Repo.all()
  end

  def list_orders_history(flop) do
    Flop.validate_and_run(OrderHistory, flop, for: OrderHistory)
  end

  def list_orders_history(%{} = flop, opts) when is_list(opts) do
    OrderHistory
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: OrderHistory)
  end

  def list_displayable_orders_history(%{} = flop, opts) when is_list(opts) do
    OrderHistory
    |> status_filter([:ready, :paid, :delivered])
    |> apply_filters(opts)
    |> Flop.validate_and_run(flop, for: OrderHistory)
  end

  def get_order_product_by_ids(order_id, product_id, size) do
    OrdersProducts
    |> where(order_id: ^order_id)
    |> where(product_id: ^product_id)
    |> where(size: ^size)
    |> Repo.one()
  end

  def get_order_draft_by_id(user_id, opts) when is_list(opts) do
    Order
    |> where(user_id: ^user_id)
    |> where(status: :draft)
    |> Repo.one()
    |> apply_filters(opts)
  end

  def list_orders_for_product(product_id) do
    OrdersProducts
    |> where(product_id: ^product_id)
    |> Repo.all()
    |> Repo.preload(:order)
  end

  def delete_order_product(%OrdersProducts{} = order_product) do
    Repo.delete(order_product)
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
