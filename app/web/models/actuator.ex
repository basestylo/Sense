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
    |> validate_inclusion(:type, ["button", "value", "slider"])
    |> validate_value_by_type
  end

  def validate_value_by_type(changeset, options \\ []) do
    value = get_field(changeset, :value)
    type = get_field(changeset, :type)

    case type do
      "button" -> validate_button(value, changeset)
      "slider" -> validate_slider(value, changeset)
      _ -> changeset
    end
  end

  def validate_button(value, changeset) do
    if value != 0 && value != 1 do
      add_error(changeset, :value, "Invalid value for button, it should be 0 or 1")
    else
      changeset
    end
  end

  def validate_slider(value, changeset) do
    IO.puts value
    if value < 0 || value > 1024 do
      add_error(changeset, :value, "Invalid value for button, it should be 0 or 1")
    else
      changeset
    end
  end
end
