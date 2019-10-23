defmodule Sense.Repo do
  use Ecto.Repo,
    otp_app: :sense,
    adapter: Ecto.Adapters.Postgres
end
