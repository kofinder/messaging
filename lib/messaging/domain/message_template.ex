defmodule Messaging.MessageTemplate do
  use Ecto.Schema

  @primary_key {:id, :string, autogenerate: false}
  schema "message_schedule_template" do
    field :lang_cd, :string
    field :event_type, NotificationEventType
    field :title, :string
    field :body, :string
    field :thumb, :string
  end
end
