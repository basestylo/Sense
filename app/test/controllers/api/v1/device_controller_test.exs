defmodule Sense.Api.V1.DeviceControllerTest do
  use Sense.ConnCase
  import Sense.Factory

  @device_valid_attrs %{name: "Name", description: "short description"}
  @device_invalid_attrs %{name: "", description: ""}

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, api_v1_device_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    device = insert(:device)

    conn = get conn, api_v1_device_path(conn, :show, device)
    assert json_response(conn, 200)["data"] == %{
      "name" => device.name,
      "description" => device.description,
      "id" => device.id,
      "user_id" => device.user.id
    }
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, api_v1_device_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    user = insert(:user)
    attributes = %{
      user_id: user.id,
      name: "MyNewDevice",
      description: "asdfasdf"
    }

    conn = post conn, api_v1_device_path(conn, :create), device: attributes

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Sense.Device, name: "MyNewDevice")
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, api_v1_device_path(conn, :create), device: @device_invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    device = insert(:device)

    conn = put conn, api_v1_device_path(conn, :update, device.id), device: @device_valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Sense.Device, @device_valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    device = insert(:device)
    conn = put conn, api_v1_device_path(conn, :update, device.id), device: @device_invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    device = insert(:device)
    conn = delete conn, api_v1_device_path(conn, :delete, device)
    assert response(conn, 204)
    refute Repo.get(Sense.Device, device.id)
  end
end
