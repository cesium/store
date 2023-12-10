defmodule Store.Utils do
  alias StoreWeb.Router.Helpers, as: Routes

  def capitalize_status(status) do
    status
    |> Atom.to_string()
    |> String.capitalize()
  end

  def draw_qr_code(order) do
    internal_route = Routes.admin_order_show_path(StoreWeb.Endpoint, :show, order.id)
    url = build_url() <> internal_route

    url
    |> QRCodeEx.encode()
    |> QRCodeEx.svg(color: "#1F2937", width: 295, background_color: :transparent)
  end

  def draw_qr_code_base64(order_id) do
    internal_route = Routes.admin_order_show_path(StoreWeb.Endpoint, :show, order_id)
    url = build_url() <> internal_route

    url
    |> QRCodeEx.encode()
    |> QRCodeEx.png(color: <<0, 0, 0>>, width: 140)
    |> Base.encode64()
  end

  defp build_url do
    "https://#{Application.fetch_env!(:store, StoreWeb.Endpoint)[:url][:host]}"
  end
end
