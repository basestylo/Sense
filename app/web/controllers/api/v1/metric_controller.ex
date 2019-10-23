defmodule Sense.Api.V1.MetricController do
  use Sense.Web, :controller
  alias Sense.{Device, Metric}

  def index(conn, %{"device_id" => device_id}) do
    metrics = Metric |> where([m], m.device_id == ^device_id) |> Repo.all
    render(conn, "index.json", metrics: metrics)
  end

  def create(conn, %{"metric" => metric_params, "device_id" => device_id}) do
    device = Repo.get!(Device, device_id)
    changeset = Metric.changeset(%Metric{device_id: device.id}, metric_params)

    case Repo.insert(changeset) do
      {:ok, metric} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", api_v1_device_metric_path(conn, :show, device_id, metric))
        |> render("show.json", metric: metric)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Sense.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    metric = Repo.get!(Metric, id)
    render(conn, "show.json", metric: metric)
  end

  def update(conn, %{"id" => id, "device_id" => device_id, "metric" => metric_params}) do
    metric = Repo.get!(Metric, id)
    changeset = Metric.changeset(metric, metric_params)

    case Repo.update(changeset) do
      {:ok, metric} ->
        render(conn, "show.json", metric: metric)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(Sense.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id, "device_id" => device_id}) do
    metric = Repo.get_by!(Metric, id: id, device_id: device_id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(metric)

    send_resp(conn, :no_content, "")
  end
end
