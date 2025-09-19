defmodule Messaging.MessageToken do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "message_token" do
    field :platform, :string
    field :permission, :string
    field :fcm_token, :string

    belongs_to :user, Messaging.User, type: Ecto.UUID
    timestamps([{:inserted_at, :created_at}])
  end

  @required_fields [:platform, :permission, :fcm_token, :user_id]

  @doc false
  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> assoc_constraint(:user)
  end

end
