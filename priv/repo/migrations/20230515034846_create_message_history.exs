defmodule Messaging.Repo.Migrations.CreateMessageHistory do
  use Ecto.Migration

  def change do
    create table(:message_history, primary_key: false) do

      add :id, :uuid, primary_key: true, null: false

      add :title, :string, null: false

      add :body, :string, null: false

      add :thumb, :string, null: true

      add :event_type, :string

      add :status, :string, values: [:READ, :UNREAD]

      add :user_id, references("users"), type: Ecto.UUID, null: false

      timestamps()
    end

    create index(:message_history, [:user_id])
  end

end
