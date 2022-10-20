defmodule Store.Oauth.ResourceOwners do
  @moduledoc false

  @behaviour Boruta.Oauth.ResourceOwners
  alias Boruta.Oauth.ResourceOwner
  alias Store.Accounts.User
  alias Store.Repo

  @impl Boruta.Oauth.ResourceOwners
  def get_by(email: email) do
    case Repo.replica().get_by(User, email: email) do
      %User{id: id, email: email} ->
        {:ok, %ResourceOwner{sub: Integer.to_string(id)}}

      _ ->
        {:error, "User not found."}
    end
  end

  def get_by(sub: sub) do
    case Repo.replica().get_by(User, id: String.to_integer(sub)) do
      %User{id: id} ->
        {:ok, %ResourceOwner{sub: Integer.to_string(id)}}

      _ ->
        {:error, "User not found."}
    end
  end

  def get_from(%Boruta.Oauth.ResourceOwner{} = resource_owner) do
    case resource_owner do
      %{email: email} -> Repo.replica().get_by(User, email: email)
      %{sub: sub} -> Repo.replica().get_by(User, id: String.to_integer(sub))
      _ -> nil
    end
  end

  @impl Boruta.Oauth.ResourceOwners
  def check_password(resource_owner, password) do
    user = Store.Accounts.get_by_email(resource_owner.email)

    if User.valid_password?(user, password) do
      :ok
    else
      {:error, "Invalid password or email."}
    end
  end

  @impl Boruta.Oauth.ResourceOwners
  def authorized_scopes(%ResourceOwner{}), do: []
end
