# General application configuration
import Config

# Configure Eto Repository
config :messaging, ecto_repos: [Messaging.Repo]

# Configure Primary Key for UUID
config :messaging, Messaging.Repo, migration_primary_key: [column: :id, type: :uuid]

# Configure Foreign Key for UUID
config :messaging, Messaging.Repo, migration_foreign_key: [column: :id, type: :uuid]

# Configure timestamp
config :messaging, Messaging.Repo,
  migration_timestamps: [type: :utc_datetime, inserted_at: :created_at, updated_at: :updated_at]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Configures firebase
config :messaging, Messaging.FCM,
  adapter: Pigeon.FCM,
  project_id: "",
  service_account_json: File.read!("./config/service-account.json")

# Configures swagger
config :messaging, :phoenix_swagger,
  swagger_files: %{
    "priv/static/swagger.json" => [
      router: Messaging.Router,     # phoenix routes will be converted to swagger paths
      endpoint: Messaging.Endpoint  # (optional) endpoint config used to set host, port and https schemes.
    ]
  }

# Configures JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Configures Swagger JSON parsing in Phoenix
config :phoenix_swagger, json_library: Jason

# Configures Envoriment
import_config "#{Mix.env()}.exs"
