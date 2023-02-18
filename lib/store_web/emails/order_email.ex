defmodule StoreWeb.Emails.OrdersEmail do
  use Phoenix.Swoosh, view: StoreWeb.EmailView, layout: {StoreWeb.LayoutView, :email}
  alias Mix.Tasks.Phx.Routes
  alias Store.Inventory
  alias Store.Repo
  alias StoreWeb.Router.Helpers, as: Routes

  def ready(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
    |> to(email)
    |> subject("[CeSIUM - Store] A tua encomenda encontra-se pronta para levantamento!")
    |> reply_to("noreply@store.cesium.di.uminho.pt")
    |> assign(:link, frontend_url <> "/orders/" <> id)
    |> assign(:order, Inventory.get_order!(id) |> Repo.preload(:products))
    |> assign(:qr_code_base64, draw_qr_code_base64(id))
    |> render_body(:order_status_ready)
  end

  def ordered(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
    |> to(email)
    |> subject("[CeSIUM - Store] A tua encomenda foi realizada com sucesso!")
    |> reply_to("noreply@store.cesium.di.uminho.pt")
    |> assign(:link, frontend_url <> "/orders/" <> id)
    |> assign(:order, Inventory.get_order!(id) |> Repo.preload(:products))
    |> assign(:qr_code_base64, draw_qr_code_base64(id))
    |> render_body(:order_status_ordered)
  end

  def paid(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
    |> to(email)
    |> subject("[CeSIUM - Store] A tua encomenda foi paga com sucesso!")
    |> reply_to("noreply@store.cesium.di.uminho.pt")
    |> assign(:link, frontend_url <> "/orders/" <> id)
    |> assign(:order, Inventory.get_order!(id) |> Repo.preload(:products))
    |> assign(:qr_code_base64, draw_qr_code_base64(id))
    |> render_body(:order_status_paid)
  end

  def delivered(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
    |> to(email)
    |> subject("[CeSIUM - Store] A tua encomenda foi entregue com sucesso!")
    |> reply_to("noreply@store.cesium.di.uminho.pt")
    |> assign(:link, frontend_url <> "/orders/" <> id)
    |> assign(:order, Inventory.get_order!(id) |> Repo.preload(:products))
    |> render_body(:order_status_delivered)
  end

  def canceled(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
    |> to(email)
    |> subject("[CeSIUM - Store] A tua encomenda foi cancelada!")
    |> reply_to("noreply@store.cesium.di.uminho.pt")
    |> assign(:link, frontend_url <> "/orders/" <> id)
    |> assign(:order, Inventory.get_order!(id) |> Repo.preload(:products))
    |> assign(:qr_code_base64, draw_qr_code_base64(id))
    |> render_body(:order_status_canceled)
  end

  defp draw_qr_code_base64(order_id) do
    Routes.admin_order_show_path(StoreWeb.Endpoint, :show, order_id)
    |> QRCodeEx.encode()
    |> QRCodeEx.png(color: <<0, 0, 0>>, width: 140)
    |> Base.encode64()
  end
end
