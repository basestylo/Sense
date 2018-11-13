defmodule Sense.Api.V1.MeasureController do
  use Sense.Web, :controller
  alias Sense.{Measure, Metric}

  def index(conn, %{"metric_id" => metric_id}) do
    metric = Repo.get!(Metric, metric_id)
    measures = Measure.by_metric(metric)
    render(conn, "index.json", measures: measures)
  end

  def create(conn, %{"measure" => %{"value" => value}, "metric_id" => metric_id}) do
    metric = Repo.get!(Metric, metric_id)

    case Measure.write_measure(metric, value) do
      :ok->
        conn
        |> put_status(:created)
        |> render("show.json", %{values: %{value: value, metric_id: metric_id}})
      _ ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Sense.Api.V1.MeasureView, "error.json", error: "Create action failed")
    end
  end

  def delete(conn, %{"metric_id" => metric_id, "device_id" => device_id}) do
    metric = Repo.get_by!(Metric, id: metric_id, device_id: device_id)
    Measure.delete_measures(metric)

    send_resp(conn, :no_content, "")
  end
end
