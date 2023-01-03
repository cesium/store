defmodule StoreWeb.UserRegistrationController do
  use StoreWeb, :controller

  alias Store.Accounts
  alias Store.Accounts.User
  alias StoreWeb.UserAuth
  alias StoreWeb.Authorization
  import StoreWeb.Emails.AuthEmails
  alias Store.Mailer

  def new(conn, _params) do
    changeset = Accounts.change_user_registration(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    user_params =
      user_params
      |> Map.put("role", :user)
      |> Map.put("verified", false)

    case Accounts.register_user(user_params) do
      {:ok, _} ->
        conn

        |> put_flash(:info, "You have been registered, please check your email to verify your account")
        |> redirect(to: Routes.home_index_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def verify(conn, %{"token" => token}) do
    with {:ok, %{"email" => email}} <- Authorization.decode_and_verify(token),
         {:ok, %User{} = user} <- Accounts.verify_user_emails(email) do
      conn
      |> Authorization.Plug.sign_in(user, %{role: user.role})
      |> put_flash(:info, "Your email has been verified")
    end
  end


  def resend(conn, _params) do
    current_user = conn.assigns.current_user

    if current_user.verified do
      conn
      |> send_resp(:no_content, "")
    else
      send_verification_token(current_user)

      conn
      |> send_resp(:created, "")
    end
  end

  defp send_verification_token(user) do
    {:ok, token, _claims} =
      Authorization.encode_and_sign(user, %{email: user.email}, ttl: {15, :minute})

    verify_user_email(token, to: user.email) |> Mailer.deliver()
  end
end
