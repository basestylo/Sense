defmodule Sense.Api.V1.MetricControllerTest do
  use Sense.ConnCase
  import Sense.Factory
  alias Sense.{Device, Metric}

  @valid_attrs %{description: "some content", name: "some content"}
  @invalid_attrs %{description: ""}

  setup %{conn: conn} do
    metric = insert(:metric)
    {:ok, %{conn: put_req_header(conn, "accept", "application/json"), device: metric.device, metric: metric}}
  end

  test "lists all entries on index", %{conn: conn, device: device, metric: metric} do
    conn = get conn, api_v1_device_metric_path(conn, :index, device.id)
    assert json_response(conn, 200)["data"] == [%{"description" => metric.description,
                                                  "device_id" => metric.device.id,
                                                  "id" => metric.id,
                                                  "name" => metric.name}]
  end

  test "shows chosen resource", %{conn: conn, device: device, metric: metric} do
    conn = get conn, api_v1_device_metric_path(conn, :show, device.id, metric)
    assert json_response(conn, 200)["data"] == %{"id" => metric.id,
      "name" => metric.name,
      "description" => metric.description,
      "device_id" => metric.device_id}
  end

  test "renders page not found when id is nonexistent", %{conn: conn, device: device} do
    assert_error_sent 404, fn ->
      conn = get conn, api_v1_device_metric_path(conn, :show, -1, -1)
      assert json_response(conn, 404)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn, device: device} do
    conn = post conn, api_v1_device_metric_path(conn, :create, device.id), metric: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Metric, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, device: device} do
    conn = post conn, api_v1_device_metric_path(conn, :create, device.id), metric: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn, device: device, metric: metric} do
    conn = put conn, api_v1_device_metric_path(conn, :update, device.id, metric), metric: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Metric, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn, device: device, metric: metric} do
    conn = put conn, api_v1_device_metric_path(conn, :update, device.id, metric), metric: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn, device: device, metric: metric} do
    conn = delete conn, api_v1_device_metric_path(conn, :delete, device.id, metric)
    assert response(conn, 204)
    refute Repo.get(Metric, metric.id, device_id: device.id)
  end
end
