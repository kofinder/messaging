defmodule Messaging.ShopNotification do

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "shop_notification" do
    field :event_type, NotificationEventType

    belongs_to :shop, Messaging.Shop, type: Ecto.UUID

    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(struct, attrs \\ %{}) do
    struct
    |> cast(attrs, [:event_type])
    |> cast_assoc(:shop, required: true)
    |> validate_required([:event_type, :shop])
  end

end
