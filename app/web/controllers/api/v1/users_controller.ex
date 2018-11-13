defmodule Sense.Api.V1.UserController do
  use Sense.Web, :controller
  alias Sense.User
  import Sense.Factory

  def show(conn) do
    user = build(:user)
    render(conn, "show.json", resource: user)
  end

  def update(conn, %{"user" => resource_params}) do
    changeset = User.changeset(conn.assigns[:resource], resource_params)

    case Repo.update(changeset) do
      {:ok, resource} ->
        render(conn, "show.json", resource: resource)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Sense.ErrorView, "error.json", changeset: changeset)
    end
  end

  def delete(conn) do
    #TODO use guardian to locate user by session
    id = 0
    Repo.delete!(conn.assigns[:resource])

    conn
    |> render("delete.json", %{id: id})
  end

  def create(conn, %{"user" => resource_params}) do
    changeset = User.changeset(%User{}, resource_params)

    case Repo.insert(changeset) do
      {:ok, resource} ->
        conn
        |> put_status(:created)
        |> render("show.json", resource: resource)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Sense.ErrorView, "error.json", changeset: changeset)
    end
  end
end
