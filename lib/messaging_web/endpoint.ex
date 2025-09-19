defmodule MessagingWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :messaging

  @session_options [
    store: :cookie,
    key: "_messaging_key",
    signing_salt: "SbmAd66N",
    same_site: "Lax"
  ]

  plug Plug.Static,
    at: "/",
    from: :messaging,
    gzip: false,
    only: MessagingWeb.static_paths()

  if code_reloading? do
    plug Phoenix.CodeReloader
    plug Phoenix.Ecto.CheckRepoStatus, otp_app: :messaging
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug Plug.Session, @session_options
  plug MessagingWeb.Router

end
