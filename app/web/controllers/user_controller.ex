defmodule Sense.UserController do
  use Sense.Web, :controller
  alias Sense.{Auth, Login, User}

  plug :scrub_params, "user" when action in [:create]

  def show(conn, %{"id" => id}) do
    user = Repo.get!(User, id)
    render(conn, "show.html", user: user)
  end

  def new(conn, _params) do
    changeset = User.changeset(%User{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    changeset = %User{} |> User.changeset(user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        conn
        |> Auth.login(user)
        |> put_flash(:info, "#{user.username} created!")
        |> redirect(to: user_path(conn, :show, user))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
