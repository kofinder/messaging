defmodule  Messaging.User do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, Ecto.UUID, autogenerate: true}
  schema "users" do
    field :phone, :string
    field :country_code, :string
    field :country_iso_code, :string
    field :email, :string
    field :full_name, :string

    has_one :shop, Messaging.Shop
    has_one :tokens, Messaging.MessageToken
    has_many :messages, Messaging.MessageHistory
    timestamps([{:inserted_at, :created_at}])
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:phone, :country_code, :country_iso_code])
    |> cast_assoc(:shop)
    |> cast_assoc(:tokens)
    |> validate_required([:phone, :country_code, :country_iso_code])
  end

end
