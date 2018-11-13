defmodule Sense.Api.V1.UserView do
  use Sense.Web, :view

  def render("show.json", %{resource: resource}) do
    %{user: render_one(resource, __MODULE__, "resource.json", as: :resource)}
  end

  def render("delete.json", %{id: id}) do
    %{code: 200, msg: gettext("Resource with deleted successfully"), id: id}
  end

  def render("resource.json", %{resource: user}) do
    %{
      id: user.id,
      first_name: user.first_name,
      last_name: user.last_name,
      email: user.email,
      username: user.username,
    }
  end
end
