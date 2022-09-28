defmodule Store.Repo.Seeds.Accounts do
  alias Store.Repo
  alias Store.Accounts.User

  @user File.read!("priv/fake/user.txt") |> String.split("\n")

  def run do
    seed_users()
  end


  def seed_users do
    case Repo.all(User) do
      [] ->
        for user <- @user do
          email =
            String.downcase(user)
            |> String.normalize(:nfd)
            |> String.replace(~r/[^A-z\s]/u, "")
            |> String.replace(" ", "_")

          %{
            email: email <> "@mail.pt",
            password: "Password1234",
            role: :user,
            partnership: Enum.random([false, true])
          }
          |> insert_user()
        end


        [
          %{
            email: "mario@gmail.com",
            password: "Password1234",
            role: :admin
          },
          %{
            email: "rui@gmail.com",
            password: "Password1234",
            role: :admin
          }
        ]
        |> Enum.each(&insert_user/1)

      _ ->
        Mix.shell().error("Found users, aborting seeding users.")
    end
  end

  defp insert_user(attrs \\ []) do
    %User{}
    |> User.registration_changeset(attrs)
    |> Repo.insert!()
  end
end

Store.Repo.Seeds.Accounts.run()
