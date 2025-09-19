import Config

# Configure your database
config :messaging, Messaging.Repo,
  username: "",
  password: "",
  hostname: "",
  database: "",
  stacktrace: true,
  stacktrace: true,
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

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

# Do not print debug messages in production
config :logger, level: :info
