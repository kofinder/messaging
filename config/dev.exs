import Config

# Configure your database
config :messaging, Messaging.Repo,
  username: "",
  password: "",
  hostname: "",
  database: "",
  stacktrace: true,
  pool_size: 10,
  show_sensitive_data_on_connection_error: true

config :messaging, MessagingWeb.Endpoint,
  http: [port: 3002],
  server: true,
  render_errors: [formats: [json: MessagingWeb.ErrorJSON], layout: false],
  pubsub_server: Messaging.PubSub,
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "vGdtV14a5yLP+5Vl4w8vQVnMw7KEHffYE6b7QLhcVhM1iF/wPh1T3gjRW6ahzuoW",
  watchers: []

# Do not include metadata nor timestamps in development logs
config :logger, :console, format: "[$level] $message\n"

# Set a higher stacktrace during development. Avoid configuring such
# in production as building large stacktraces may be expensive.
config :phoenix, :stacktrace_depth, 20

# Initialize plugs at runtime for faster development compilation
config :phoenix, :plug_init_mode, :runtime
