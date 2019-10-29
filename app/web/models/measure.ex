defmodule Sense.Measure do
  use Instream.Series
  alias Sense.{Influx}
  import Instream.Query.Builder

  series do
    measurement "device_metrics"

    tag :metric_id

    field :value
  end

  @moduledoc """
  Metric's Measure

  Is the value sent by the Device for a Metric
  """

  def by_metric(metric) do
    results = Sense.Measure
    |> from
    |> select(["value"])
    |> where(%{metric_id: Integer.to_string(metric.id)})
    |> Influx.query()

    data = results[:results] |> List.first
    case data[:series] do
      nil ->
        []
      _ ->
        data = data[:series] |> List.first
      Enum.map(data[:values], fn([timestamp, value]) -> %{value: value, timestamp: timestamp} end)
    end
  end

  def write_measure(metric, value, async) when is_integer(value) do
    write_measure(metric, value / 1, async)
  end

  def write_measure(metric, value, async \\ false) when is_float(value) do
    case value do
      nil ->
        :error
      _ ->
        data = %Sense.Measure{}
        data = %{data | fields: %{data.fields | value: value}}
        data = %{data | tags: %{data.tags | metric_id: metric.id}}

        IO.inspect data
        Influx.write(data, async: async)
    end
  end

  def delete_measures(metric) do
    "DELETE FROM device_metrics WHERE metric_id = #{metric.id}"
    |> Influx.execute(method: :post)

    :ok
  end

  def create_database do
    "device_metrics"
    |> Instream.Admin.Database.create()
    |> Influx.execute()
  end

  def delete_database do
    "device_metrics"
    |> Instream.Admin.Database.drop()
    |> Influx.execute()
  end
end
