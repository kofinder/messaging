defmodule  Messaging.Shop do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "shop" do
    field :shop_name, :string
    field :shop_code, :string
    field :shop_type, Ecto.Enum, values: [:RETAIL, :WHOLESALE]

    has_one :notification, Messaging.ShopNotification
    belongs_to :user, Messaging.User, type: Ecto.UUID

    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(shop, attrs) do
    shop
    |> cast(attrs, [:shop_name, :shop_code])
    |> validate_required([:shop_name, :shop_code])
    |> assoc_constraint(:user)
  end

end
