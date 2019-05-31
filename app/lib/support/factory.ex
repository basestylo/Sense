defmodule Sense.Factory do
  use ExMachina.Ecto, repo: Sense.Repo
  Faker.start
  alias Sense.{Actuator, Device, Metric, User}

  @moduledoc """
  Factory for testing, It has que basic objects
  """

  def user_factory do
    %User{
      email: sequence(:email, &"#{&1}mail@example.local"),
      first_name: "John",
      last_name: "Doe",
      username: "johndoe",
      encrypted_password: Bcrypt.hashpwsalt("password")
    }
  end

  def device_factory do
    %Device{
      name: "Example",
      description: "Description",
      user: build(:user)
    }
  end

  def metric_factory do
    %Metric{
      name: "Example",
      description: "Description",
      device: build(:device)
    }
  end

  def actuator_factory do
    %Actuator{
      name: "Example",
      description: "Description",
      type: "button",
      value: 1,
      device: build(:device)
    }
  end
end
