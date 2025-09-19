defmodule Messaging.MessageTokenRepo do
  import Ecto.Query, warn: false
  require Logger

  alias Messaging.Repo
  alias Messaging.MessageToken

  def list_tokens, do: Repo.all(MessageToken)

  def get_token!(id), do: Repo.get!(MessageToken, id)

  def get_message_token(userId) do
    MessageToken
    |> where(user_id: ^userId)
    |> Repo.one()
  end

  def create_token(attrs \\ %{}) do
    %MessageToken{}
    |> MessageToken.changeset(attrs)
    |> Repo.insert()
  end

  def update_token(%MessageToken{} = token, attrs) do
    token
    |> MessageToken.changeset(attrs)
    |> Repo.update()
  end

  def delete_token(%MessageToken{} = token) do
    Repo.delete(token)
  end

  def change_token(%MessageToken{} = token, attrs \\ %{}) do
    MessageToken.changeset(token, attrs)
  end

end
