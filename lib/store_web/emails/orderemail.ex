defmodule StoreWeb.Emails.OrdersEmail do
  use Phoenix.Swoosh, view: StoreWeb.EmailView, layout: {StoreWeb.LayoutView, :email}

  def ready(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CeSIUM", "verify@cesium.link"})
    |> to(email)
    |> subject("[CeSIUM] A tua encomenda encontra-se pronta!")
    |> reply_to("noreply@cesium.link")
    |> assign(:link, frontend_url <> "/orders/" <> id)
    |> render_body(:order_status_ordered)
  end

  def ordered(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CeSIUM", "verify@cesium.link"})
    |> to(email)
    |> subject("[CeSIUM] A tua encomenda foi feita com sucesso!")
    |> reply_to("noreply@cesium.link")
    |> assign(:link, frontend_url <> "/orders/" <> id)
    |> render_body(:order_status_ordered)
  end

  def paid(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CeSIUM", "verify@cesium.link"})
    |> to(email)
    |> subject("[CeSIUM] A tua encomenda foi paga com sucesso!")
    |> reply_to("noreply@cesium.link")
    |> assign(:link, frontend_url <> "/orders/" <> id)
    |> render_body(:order_status_paid)
  end

  def delivered(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CeSIUM", "verify@cesium.link"})
    |> to(email)
    |> subject("[CeSIUM] A tua encomenda foi entregue com sucesso!")
    |> reply_to("noreply@cesium.link")
    |> assign(:link, frontend_url <> "/orders/" <> id)
    |> render_body(:order_status_delivered)
  end

  def canceled(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CeSIUM", "verify@cesium.link"})
    |> to(email)
    |> subject("[CeSIUM] A tua encomenda foi cancelada!")
    |> reply_to("noreply@cesium.link")
    |> assign(:link, frontend_url <> "/orders/" <> id)
    |> render_body(:order_status_canceled)
  end
end
