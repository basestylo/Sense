# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Sense.Repo.insert!(%Sense.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
alias Sense.Repo
alias Sense.{ User }


user_john = User.changeset(%User{}, %{
      email: "john@sense.local",
      first_name: "John",
      last_name: "Doe",
      username: "JohnDoEx"
})
|> Repo.insert!

random_user = User.changeset(%User{}, %{
      email: Faker.Internet.email,
      first_name: Faker.Name.first_name,
      last_name: Faker.Name.last_name,
      username: Faker.Internet.user_name
})
|> Repo.insert!
      
