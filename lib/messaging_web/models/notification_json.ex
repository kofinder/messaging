defmodule MessagingWeb.NotificationJSON do
  alias Messaging.MessageHistory
  alias Messaging.MessageToken

  def index(%{notification: notification}) do
    %{data: for(notification <- notification, do: messageTransform(notification))}
  end

  def notificationJson(%{notifications: paging}) do
    %{data: %{
      "pageNumber"=> paging.page_number,
      "pageSize" => paging.page_size,
      "totalPages" => paging.total_pages,
      "totalCount" => paging.total_entries,
      "items" => for(ele <- paging.entries, do: messageTransform(ele))
    }}
  end

  def show(%{notification: notification}) do
    %{data: messageTransform(notification)}
  end

  def commandJson(%{command: command}) do
    %{data: command}
  end

  def statusJson(%{status: status}) do
    %{data: status}
  end

  def toJson(%{token: token}) do
    %{data: tokenTransform(token)}
  end

  defp tokenTransform(%MessageToken{} = model) do
    %{
      id: model.id,
      userId: model.user_id,
      token: model.fcm_token,
      createdAt: model.created_at,
      updatedAt: model.updated_at
    }
  end

  defp messageTransform(%MessageHistory{} = model) do
    %{
      id: model.id,
      title: model.title,
      body: model.body,
      thumb: model.thumb,
      status: model.status,
      userId: model.user_id,
      createdAt: model.created_at,
      updatedAt: model.updated_at
    }
  end

end
