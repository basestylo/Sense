defmodule Sense.UserTest do
  use Sense.ModelCase

  alias Sense.User

  @valid_attrs %{
    email: "fake@email.local",
    first_name: "John",
    last_name: "Doe",
    username: "johndoe",
    password: "johndoe123"
  }
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
