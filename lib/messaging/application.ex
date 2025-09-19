defmodule Messaging.Application do

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      MessagingWeb.Telemetry,

      # Start the Ecto repository
      Messaging.Repo,

      #Start Firebase could messaging sytem
      Messaging.FCM,

      Messaging.Listener,

      # Start the PubSub system
      {Phoenix.PubSub, name: Messaging.PubSub},

      # Start the Endpoint (http/https)
      MessagingWeb.Endpoint,
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Messaging.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MessagingWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
