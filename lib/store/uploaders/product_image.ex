defmodule Store.Uploaders.ProductImage do
  @moduledoc """
  ProductImage is used for product images.
  """

  use Waffle.Definition
  use Waffle.Ecto.Definition

  alias Store.Inventory.Product

  @versions [:original, :medium, :thumb]
  @extension_whitelist ~w(.jpg .jpeg .png)

  def validate({file, _}) do
    file.file_name
    |> Path.extname()
    |> String.downcase()
    |> then(&Enum.member?(@extension_whitelist, &1))
    |> case do
      true -> :ok
      false -> {:error, "Invalid file type. Only .jpg, .jpeg and .png are allowed."}
    end
  end

  def transform(:thumb, _) do
    {:convert, "-strip -thumbnail 100x150^ -gravity center -extent 100x150 -format png", :png}
  end

  def transform(:medium, _) do
    {:convert, "-strip -thumbnail 400x600^ -gravity center -extent 400x600 -format png", :png}
  end

  def filename(version, _) do
    version
  end

  def storage_dir(_version, {_file, %Product{} = scope}) do
    "uploads/store/#{scope.id}"
  end

  # Provide a default URL if there hasn't been a file uploaded
  def default_url(version) do
    "uploads/store/product_image_#{version}.png"
  end
end
