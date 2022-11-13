defmodule StoreWeb.EmailController do
  use StoreWeb, :controller
  alias Store.Accounts
  alias Store.Mailer
  alias Store.Events
  alias  StoreWeb.Emails.OrdersEmail

  action_fallback StoreWeb.FallbackController

  def send_email(users, email) do
    users
    |> List.foldl(
      %{success: [], fail: []},
      fn user, accumulator ->
        case Mailer.deliver(email.(user)) do
          {:ok, _} ->
            %{success: [user.email | accumulator[:success]], fail: accumulator[:fail]}

          {:error, _} ->
            %{success: [accumulator[:success]], fail: [user.email | accumulator[:fail]]}
        end
      end
    )
  end
end
