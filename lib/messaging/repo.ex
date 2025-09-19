defmodule Messaging.Repo do
  use Ecto.Repo, otp_app: :messaging, adapter: Ecto.Adapters.Postgres
  use Scrivener, page_size: 10

  alias Postgrex.Notifications

  def init(_, opts), do: {:ok, opts}

  def listen(event_name) do
    with {:ok, pid} <- Notifications.start_link(__MODULE__.config()),
         {:ok, ref} <- Notifications.listen(pid, event_name) do
      {:ok, pid, ref}
    end
  end

end
