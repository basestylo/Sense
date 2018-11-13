defmodule Sense.MeasureTest do
  use Sense.ModelCase
  import Sense.Factory
  alias Sense.{Measure, Metric}

  setup do
    Measure.delete_database
    Measure.create_database
  end

  @valid_attrs %{tag: "1", value: 1}
  @invalid_attrs %{}

  test "create a measure for a metric" do
    metric = insert(:metric)
    assert Measure.write_measure(metric, 1) == :ok
  end

  test "delete all measures for a metric" do
    metric = insert(:metric)
    Measure.write_measure(metric, 1)
    assert Measure.delete_measures(metric) == :ok
  end

  test "query metric's measurements with by_metric" do
    metric = insert(:metric)
    Measure.write_measure(metric, 2)
    Measure.write_measure(metric, 1)

    assert Measure.by_metric(metric)
  end
end
