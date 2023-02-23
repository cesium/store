defmodule Store.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Store.Accounts` context.
  """

  alias Store.Accounts
  alias Store.Accounts.User
  alias Store.Repo

  def unique_user_email, do: "user#{System.unique_integer()}@example.com"
  def valid_user_password, do: "hello world!"
  def valid_role, do: :user
  def valid_partnership, do: true
  def valid_confirmed_at, do: DateTime.utc_now()

  def valid_user_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      role: valid_role(),
      partnership: valid_partnership()
    })
  end

  def valid_user_attributes_with_confirmedat(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_user_email(),
      password: valid_user_password(),
      role: valid_role(),
      partnership: valid_partnership()
    })
  end

  def user_fixture(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.register_user()

    user2 =
      user
      |> User.confirm_changeset()
      |> Repo.update!()

    user2
  end

  def user_fixture_not_confirmed(attrs \\ %{}) do
    {:ok, user} =
      attrs
      |> valid_user_attributes()
      |> Accounts.register_user()

    user
  end

  def extract_user_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")

    if captured_email == %{} do
      nil
    else
      [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")

      token
    end
  end
end
