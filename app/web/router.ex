defmodule Sense.Router do
  use Sense.Web, :router
  use Plug.ErrorHandler

  defp handle_errors(conn, %{kind: kind, reason: reason, stack: stacktrace}) do
    Rollbax.report(kind, reason, stacktrace, %{method: conn.method})
  end

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :with_session do
    plug Guardian.Plug.VerifySession
    plug Guardian.Plug.LoadResource
    plug Sense.CurrentUser
  end

  pipeline :session_required do
    plug Guardian.Plug.EnsureAuthenticated, handler: Sense.GuardianErrorHandler
  end

  scope "/mqtt", Sense do
    post "/user", MqttAuthenticatorController, :user
    post "/superuser", MqttAuthenticatorController, :superuser
    post "/acl", MqttAuthenticatorController, :acl
  end

  scope "/", Sense do
    pipe_through [:browser, :with_session]

    get "/", PageController, :index
    resources "/users", UserController, only: [:new, :create]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
  end

  scope "/", Sense do
    pipe_through [:browser, :with_session, :session_required]

    resources "/users", UserController, only: [:show]
  end

  # API Scope
  scope "/api", Sense.Api, as: :api do
    pipe_through [:api]

    scope "/v1", V1, as: :v1 do
      resources "/user", UserController, only: [:delete, :update, :show, :create], singleton: true
      resources "/devices", DeviceController, except: [:new, :edit] do
        resources "/actuators", ActuatorController, except: [:new, :edit]
        resources "/metrics", MetricController, except: [:new, :edit] do
          resources "/measures", MeasureController, only: [:index, :create]
          delete "/measures", MeasureController, :delete
        end
      end
    end
  end
end
