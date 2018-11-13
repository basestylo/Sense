defmodule Sense.Api.V1.DeviceView do
  use Sense.Web, :view

  def render("index.json", %{resources: resources}) do
    %{data: render_many(resources, __MODULE__, "device.json")}
  end

  def render("show.json", %{resource: resource}) do
    %{data: render_one(resource, __MODULE__, "device.json")}
  end

  def render("delete.json", %{id: id}) do
    %{code: 200, msg: gettext("Resource with deleted successfully"), id: id}
  end

  def render("device.json", %{device: resource}) do
    %{id: resource.id,
      name: resource.name,
      description: resource.description,
      user_id: resource.user_id
    }
  end
end
