defmodule Sense.Api.V1.MeasureControllerTest do
  use Sense.ConnCase
  import Sense.Factory
  alias Sense.Measure

  setup %{conn: conn} do
    metric = insert(:metric)
    {:ok, %{conn: put_req_header(conn, "accept", "application/json"), device: metric.device, metric: metric}}
  end

  test "lists all entries on index", %{conn: conn, metric: metric, device: device} do
    Measure.write_measure(metric, 1)
    Measure.write_measure(metric, 2)
    Measure.write_measure(metric, 3)

    :timer.sleep(1000)

    conn = get conn, api_v1_device_metric_measure_path(conn, :index, device.id, metric.id )
    measure = json_response(conn, 200)["data"] |> List.first
    assert measure["value"] == 1
  end

  test "creates and renders resource when data is valid", %{conn: conn, device: device, metric: metric} do
    conn = post conn, api_v1_device_metric_measure_path(conn, :create, device.id, metric.id), measure: %{"value" => 1}
    IO.inspect Sense.Measure.by_metric(metric)
    refute Sense.Measure.by_metric(metric), []
    assert json_response(conn, 201)["data"]["value"] == 1
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn, device: device, metric: metric} do
    conn = post conn, api_v1_device_metric_measure_path(conn, :create, device.id, metric.id), measure: %{value: nil}

    assert Sense.Measure.by_metric(metric), []
    assert json_response(conn, 422)["error"] != %{}
  end

  test "deletes resources", %{conn: conn, device: device, metric: metric} do
    conn = delete conn, api_v1_device_metric_measure_path(conn, :delete, device.id, metric.id)

    assert response(conn, 204)
    assert Measure.by_metric(metric), []
  end
end
