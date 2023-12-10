defmodule StoreWeb.Emails.AuthEmails do
  @moduledoc """
  A module to build auth related emails.
  """

  use Phoenix.Swoosh, view: StoreWeb.EmailView, layout: {StoreWeb.LayoutView, :email}
  alias Store.Mailer

  def reset_password_email(id, to: email) do
    frontend_url = Application.fetch_env!(:store, StoreWeb.Endpoint)[:frontend_url]

    email =
      new()
      |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
      |> to(email)
      |> subject("[CeSIUM - Store] Instruções para repor a password")
      |> reply_to("noreply@store.cesium.di.uminho.pt")
      |> assign(:link, frontend_url <> "/users/reset_password/" <> id)

    Task.start(fn -> {:ok, _metadata} = Mailer.deliver(email) end)
  end

  def confirm_account_email(id, to: email) do
    email =
      new()
      |> from({"CeSIUM - Store", "noreply@store.cesium.di.uminho.pt"})
      |> to(email)
      |> subject("[CeSIUM - Store] Confirmação da conta")
      |> reply_to("noreply@store.cesium.di.uminho.pt")
      |> assign(:link, id)
      |> assign(:user, Store.Accounts.get_user_by_email(email))
      |> render_body("confirm_account.html")

    Task.start(fn -> {:ok, _metadata} = Mailer.deliver(email) end)
  end
end
