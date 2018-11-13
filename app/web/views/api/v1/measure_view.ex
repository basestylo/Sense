defmodule Sense.Api.V1.MeasureView do
  use Sense.Web, :view

  def render("index.json", %{measures: measures}) do
    %{data: render_many(measures, __MODULE__, "measure.json")}
  end

  def render("show.json", %{values: metric}) do
    %{data: render_one(metric, __MODULE__, "measure.json")}
  end

  def render("error.json", %{error: error}) do
    %{error: error}
  end

  def render("measure.json", %{measure: measure}) do

    %{value: measure[:value],
      timestamp: measure[:timestamp]}
  end
end
