defmodule Sense.Actuator do
  use Sense.Web, :model

  schema "actuators" do
    field :name, :string
    field :description, :string
    field :type, :string
    field :value, :integer
    belongs_to :device, Sense.Device

    timestamps()
  end

  @moduledoc """
  Device's Actuator

  It's the repesentation of an actuator for a device, Has state, and user can modify it.
  """

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :device_id, :type, :value])
    |> validate_required([:name, :description])
    |> validate_inclusion(:type, ["button", "value"])
    |> validate_value_by_type
  end

  def validate_value_by_type(changeset, options \\ []) do
    value = get_field(changeset, :value)
    type = get_field(changeset, :type)
    if type == "value" or type == "button" and (value == 0 or value == 1) do
      changeset
    else
      add_error(changeset, :value, "Invalid value for button, it should be 0 or 1")
    end
  end
end
