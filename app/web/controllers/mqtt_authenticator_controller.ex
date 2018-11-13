defmodule Sense.MqttAuthenticatorController do
  use Sense.Web, :controller
  alias Sense.{User}

  def user(conn, %{"username" => username, "password" => password}) do
    case Repo.get_by(User, username: username, encrypted_password: password) do
      nil ->
        conn
        |> put_status(:unauthorized)
        |> text("NOPE")
      _ ->
        conn
        |> put_status(:ok)
        |> text("OK")
    end
  end

  def superuser(conn, %{"username" => user}) do
    case user do
      "JohnDoEx" ->
        conn
        |> put_status(:ok)
        |> text("OK")
      _ ->
        conn
        |> put_status(:unauthorized)
        |> text("NOPE")
    end
  end

  def acl(conn, params) do
    # TODO: Perform topic and acc checks
    conn
    |> put_status(:ok)
    |> text("OK #{inspect params}")
  end
end
