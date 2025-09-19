defmodule Messaging.Repo.Migrations.CreateShopNotification do

  use Ecto.Migration

  def change do
    create table(:shop_notification, primary_key: false) do

      add :id, :uuid, primary_key: true, null: false

      add :event_type, :string

      add :shop_id, references("shop"), type: Ecto.UUID, null: false

      timestamps()
    end

    create unique_index(:shop_notification, [:shop_id])

  end

end
