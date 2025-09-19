defmodule Messaging.MessageHistory do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "message_history" do
    field :title, :string
    field :body, :string
    field :thumb, :string
    field :event_type, NotificationEventType
    field :status, MessageStatusType

    belongs_to :user, Messaging.User, type: Ecto.UUID

    timestamps([{:inserted_at, :created_at}])
  end
  @doc false
  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:title, :body, :thumb, :status, :event_type, :user_id])
    |> validate_required([:title, :body, :thumb, :status, :event_type, :user_id])
    |> assoc_constraint(:user)
  end

end
