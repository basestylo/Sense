defmodule Sense.User do
  use Sense.Web, :model

  schema "users" do
    field :email, :string
    field :first_name, :string
    field :last_name, :string
    field :username, :string
    field :encrypted_password, :string
    field :password, :string, virtual: true

    timestamps()

    # Associations
    has_many :devices, Sense.Device
  end

  @moduledoc """
  User Model
  """

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, user_params())
    |> validate_required(user_params())
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> validate_length(:password, min: 6, max: 100)
    |> generate_encrypted_password
  end

  def encrypt_password(password) do
    # Comeonin.Bcrypt.hashpwsalt(password)
    password
  end

  defp user_params do
    [:email,
     :first_name,
     :last_name,
     :username,
     :password]
  end

  defp generate_encrypted_password(current_changeset) do
    case current_changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(current_changeset, :encrypted_password, encrypt_password(password))
      _ ->
        current_changeset
    end
  end
end
