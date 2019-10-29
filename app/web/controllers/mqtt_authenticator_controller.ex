defmodule Sense.MqttAuthenticatorController do
  use Sense.Web, :controller
  alias Sense.{User}
  import Ecto.Query

  def user(conn, %{"username" => username, "password" => password}) do


    case from(u in User, where: u.username == ^username and u.encrypted_password == ^password) |> Repo.one do
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
