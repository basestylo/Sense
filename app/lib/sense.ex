defmodule Sense do
  use Application

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec

    # Define workers and child supervisors to be supervised
    children = [
      # Start the Ecto repository
      supervisor(Sense.Repo, []),
      # Start the endpoint when the application starts
      supervisor(Sense.Endpoint, []),
      # Start your own worker by calling: Sense.Worker.start_link(arg1, arg2, arg3)
      # worker(Sense.Worker, [arg1, arg2, arg3]),
      Sense.Influx.child_spec
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Sense.Supervisor]
    Supervisor.start_link(children, opts)

    {:ok, _pid}= Tortoise.Supervisor.start_child(
      client_id: "my_client_id", user_name: "JohnDoEx", password: "foobarfoo",
      handler: {Tortoise.Handler.SenseMQTT, []},
      server: {Tortoise.Transport.Tcp, host: System.get_env("MQTT_HOST") || "localhost", port: 1883},
      subscriptions: [{"#", 0}])
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    Sense.Endpoint.config_change(changed, removed)
    :ok
  end
end
