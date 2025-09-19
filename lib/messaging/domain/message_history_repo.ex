defmodule Messaging.MessageHistoryRepo do

  import Ecto.Query, warn: false
  alias Messaging.Repo
  alias Messaging.MessageHistory

  def list_shop_messages do
    Repo.all(MessageHistory)
  end

  # retrieve all notifiactions
  # specific limit & skip before invoke this method
  def list_all_message_with_pagianation(attrs \\ %{}) do
    userId = attrs["userId"]
    size = attrs["limit"]
    page = attrs["skip"]
    MessageHistory
      |> where(user_id: ^userId)
      |> order_by(desc: :created_at)
      |> Repo.paginate(page: page, page_size: size)
  end

  def get_unread_count(attrs \\ %{}) do
    userId = attrs["userId"]
    Repo.one(from m in MessageHistory, where: m.user_id == ^userId and m.status == "UNREAD",  select: count("*"))
  end

  def get_shop_message!(id), do: Repo.get!(MessageHistory, id)

  def create_shop_message(attrs \\ %{}) do
      %MessageHistory{}
      |> MessageHistory.changeset(attrs)
      |> Repo.insert()
  end

  def create_message_history(attrs \\ %{}) do
    %MessageHistory{}
    |> MessageHistory.changeset(attrs)
    |> Repo.insert()
  end

  def update_all_messages_status(user_id) do
    from(m in MessageHistory, where: m.user_id == ^user_id)
    |> Repo.update_all(set: [status: "READ"])
  end

  def update_message_status(messageId) do
    from(s in MessageHistory, where: s.id == ^messageId)
    |> Repo.update_all(set: [status: "READ"])
  end

  def update_shop_message(%MessageHistory{} = message, attrs) do
    message
    |> MessageHistory.changeset(attrs)
    |> Repo.update()
  end

  def delete_message(%MessageHistory{} = message) do
    Repo.delete(message)
  end

  def change_message(%MessageHistory{} = message, attrs \\ %{}) do
    MessageHistory.changeset(message, attrs)
  end

end
