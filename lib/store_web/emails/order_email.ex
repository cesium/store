defmodule StoreWeb.Emails.OrdersEmail do
  use Phoenix.Swoosh, view: StoreWeb.EmailView, layout: {StoreWeb.LayoutView, :email}

  alias Store.Inventory
  alias Store.Mailer
  alias Store.Utils

  def ready(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    email =
      new()
      |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
      |> to(email)
      |> subject("[CeSIUM - Store] A tua encomenda encontra-se pronta para levantamento!")
      |> reply_to("noreply@store.cesium.di.uminho.pt")
      |> assign(:link, frontend_url <> "/orders/" <> id)
      |> assign(:order, Inventory.get_order!(id, preloads: [:products]))
      |> assign(:qr_code_base64, Utils.draw_qr_code_base64(id))
      |> render_body("order_status_ready.html")

    Task.start(fn -> {:ok, _metadata} = Mailer.deliver(email) end)

    {:ok, email}
  end

  def ordered(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    email =
      new()
      |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
      |> to(email)
      |> subject("[CeSIUM - Store] A tua encomenda foi realizada com sucesso!")
      |> reply_to("noreply@store.cesium.di.uminho.pt")
      |> assign(:link, frontend_url <> "/orders/" <> id)
      |> assign(:order, Inventory.get_order!(id, preloads: [:products]))
      |> assign(:qr_code_base64, Utils.draw_qr_code_base64(id))
      |> render_body("order_status_ordered.html")

    Task.start(fn -> {:ok, _metadata} = Mailer.deliver(email) end)

    {:ok, email}
  end

  def paid(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    email =
      new()
      |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
      |> to(email)
      |> subject("[CeSIUM - Store] A tua encomenda foi paga com sucesso!")
      |> reply_to("noreply@store.cesium.di.uminho.pt")
      |> assign(:link, frontend_url <> "/orders/" <> id)
      |> assign(:order, Inventory.get_order!(id, preloads: [:products]))
      |> assign(:qr_code_base64, Utils.draw_qr_code_base64(id))
      |> render_body("order_status_paid.html")

    Task.start(fn -> {:ok, _metadata} = Mailer.deliver(email) end)

    {:ok, email}
  end

  def delivered(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    email =
      new()
      |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
      |> to(email)
      |> subject("[CeSIUM - Store] A tua encomenda foi entregue com sucesso!")
      |> reply_to("noreply@store.cesium.di.uminho.pt")
      |> assign(:link, frontend_url <> "/orders/" <> id)
      |> assign(:order, Inventory.get_order!(id, preloads: [:products]))
      |> render_body("order_status_delivered.html")

    Task.start(fn -> {:ok, _metadata} = Mailer.deliver(email) end)

    {:ok, email}
  end

  def canceled(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    email =
      new()
      |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
      |> to(email)
      |> subject("[CeSIUM - Store] A tua encomenda foi cancelada!")
      |> reply_to("noreply@store.cesium.di.uminho.pt")
      |> assign(:link, frontend_url <> "/orders/" <> id)
      |> assign(:order, Inventory.get_order!(id, preloads: [:products]))
      |> assign(:qr_code_base64, Utils.draw_qr_code_base64(id))
      |> render_body("order_status_canceled.html")

    Task.start(fn -> {:ok, _metadata} = Mailer.deliver(email) end)

    {:ok, email}
  end
end
