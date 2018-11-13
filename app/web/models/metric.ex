defmodule Sense.Metric do
  use Sense.Web, :model

  schema "metrics" do
    field :name, :string
    field :description, :string
    belongs_to :device, Sense.Device

    timestamps()
  end

  @moduledoc """
  Device's Metric.

  Represent a input of data from any device.
  """

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :device_id])
    |> validate_required([:name, :description])
  end
end
