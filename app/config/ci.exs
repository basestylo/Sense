use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :sense, Sense.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :info

# Configure your database
config :sense, Sense.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "ubuntu",
  password: "",
  database: "circle_test",
  hostname: "127.0.0.1",
  pool: Ecto.Adapters.SQL.Sandbox

# Reduce the number of bcrypt rounds so it does not slow down test suite.
# By default bcrypt_log_rounds is 12 and pbkdf2_rounds 160_000

config :junit_formatter,
  report_file: "report_file_test.xml",
  report_dir: Enum.join([System.get_env("CIRCLE_TEST_REPORTS") || "tmp" , "/reports"]),
  print_report_file: true
