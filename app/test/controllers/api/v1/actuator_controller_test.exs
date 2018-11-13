defmodule Sense.Api.V1.ActuatorControllerTest do
  use Sense.ConnCase
  import Sense.Factory
  alias Sense.{Actuator, Device}

  @valid_attrs %{description: "some content", name: "some content", type: "button", value: 0}
  @invalid_attrs %{description: "some content", name: "some content", type: "button", value: 1000}

  setup %{conn: conn} do
    actuator = insert(:actuator)
    {:ok, %{conn: put_req_header(conn, "accept", "application/json"), device: actuator.device, actuator: actuator}}
  end

  test "lists all entries on index", %{conn: conn, device: device, actuator: actuator} do
    conn = get conn, api_v1_device_actuator_path(conn, :index, device.id)
    assert json_response(conn, 200)["data"] == [%{"description" => actuator.description,
                                                  "device_id" => actuator.device.id,
                                                  "id" => actuator.id,
                                                  "name" => actuator.name,
                                                  "type" => actuator.type,
                                                  "value" => actuator.value}]
  end

  test "shows chosen resource", %{conn: conn, device: device, actuator: actuator} do
    conn = get conn, api_v1_device_actuator_path(conn, :show, device.id, actuator)
    assert json_response(conn, 200)["data"] == %{"id" => actuator.id,
                                                 "name" => actuator.name,
                                                 "description" => actuator.description,
                                                 "type" => actuator.type,
                                                 "value" => actuator.value,
                                                 "device_id" => actuator.device_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn, device: device} do
    assert_error_sent 404, fn ->
      conn = get conn, api_v1_device_actuator_path(conn, :show, -1, -1)
      assert json_response(conn, 404)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, device: device} do
    conn = post conn, api_v1_device_actuator_path(conn, :create, device.id), actuator: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Actuator, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, device: device} do
    conn = post conn, api_v1_device_actuator_path(conn, :create, device.id), actuator: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, device: device, actuator: actuator} do
    conn = put conn, api_v1_device_actuator_path(conn, :update, device.id, actuator), actuator: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Actuator, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, device: device, actuator: actuator} do
    conn = put conn, api_v1_device_actuator_path(conn, :update, device.id, actuator), actuator: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, device: device, actuator: actuator} do
    conn = delete conn, api_v1_device_actuator_path(conn, :delete, device.id, actuator)
    assert response(conn, 204)
    refute Repo.get(Actuator, actuator.id, device_id: device.id)
  end
end
