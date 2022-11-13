defmodule StoreWeb.Emails.AuthEmails do
  @moduledoc """
  A module to build auth related emails.
  """
  use Phoenix.Swoosh, view: StoreWeb.EmailView, layout: {StoreWeb.LayoutView, :email}

  def reset_password_email(id, to: email) do
    frontend_url = Application.fetch_env!(:bokken, StoreWeb.Endpoint)[:frontend_url]

    new()
    |> from({"CeSIUM", "noreply@cesium.di.uminho.pt"})
    |> to(email)
    |> subject("[CeSIUM] Instruções para repor a password")
    |> reply_to("noreply@coderdojobraga.org")
    |> assign(:link, frontend_url <> "/users/reset_password/" <> id)
  end
end
