defmodule Messaging.Repo.Migrations.CreateShopToken do
  use Ecto.Migration

  def change do
    create table(:message_token, primary_key: false) do

      add :id, :uuid, primary_key: true, null: false

      add :platform, :string

      add :permission, :string

      add :fcm_token, :string

      add :user_id, references("users"), type: Ecto.UUID, null: false

      timestamps()
    end

    create unique_index(:message_token, [:user_id])
  end

end
