defmodule Sense.Auth do
  import Comeonin.Bcrypt, only: [checkpw: 2, dummy_checkpw: 0]
  alias Sense.{Repo, User}

  @moduledoc """
  User Authentication

  It has the basic methods to manage user sessions and authentication
  """

  def login(conn, user) do
    conn
    |> Guardian.Plug.sign_in(user)
  end

  def login_by_email_and_pass(conn, email, given_pass) do
    login_by_defined_parameters_and_pass(conn, %{email: email}, given_pass)
  end

  def login_by_defined_parameters_and_pass(conn, parameters, given_pass) do
    user = Repo.get_by(User, parameters)
    cond do
      user && checkpw(given_pass, user.encrypted_password) ->
        {:ok, login(conn, user)}
      user ->
        {:error, :unauthorized, conn}
      true ->
        dummy_checkpw()
        {:error, :not_found, conn}
    end
  end

  def logout(conn) do
    Guardian.Plug.sign_out(conn)
  end
end
