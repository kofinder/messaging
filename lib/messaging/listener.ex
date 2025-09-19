defmodule Messaging.Listener do
  use GenServer

  alias Messaging.Repo

  require Poison

  require Pigeon

  require Logger

  @event_name "shop_notification_changed"

  def child_spec(opts) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, [opts]}
    }
  end

  def start_link(opts \\ []),
    do: GenServer.start_link(__MODULE__, opts)

  def init(opts) do
    with {:ok, _pid, _ref} <- Repo.listen(@event_name) do
      {:ok, opts}
    else
      error -> {:stop, error}
    end
  end

  def handle_info({:notification, _pid, _ref, @event_name, payload}, _state) do
    with {:ok, data} <- Poison.decode(payload, keys: :atoms) do
      case Messaging.ShopRepo.get_shop(data.record.shop_id) do
        nil -> Logger.info("Shop Owner Does Not Exist!")
        result ->
          Logger.info(result)
          case Messaging.MessageTemplateRepo.get_message_template(result.langCd, data.record.event_type) do
            nil -> Logger.info("Message Template Does Not Exist!")
            message ->
              case Messaging.MessageTokenRepo.get_message_token(result.userId) do
                nil -> Logger.info("Firebase Token Does Not Exist!")
                msgToken ->
                  options = %{ "screen" => "inventory",  "channel" => "notification", "extraInfo" => data.record.event_type  };
                  mapper = %{ 'company_name' => "momnpop", 'service' => 'product/sale', 'discount' => '10%', 'dtformat' => '05/09/2024', 'location' => 'Chiang Mai', 'address' => 'Thailand' }
                  body = :bbmustache.render(message.body, mapper)
                  noti = Pigeon.FCM.Notification.new({:token, msgToken.fcm_token}, %{"title" => message.title, "body" => body, 'thumb' => message.thumb, "data" => options })
                  Messaging.FCM.push(noti)
                  Messaging.MessageHistoryRepo.create_message_history(%{"user_id" => result.userId, "title" => message.title, "body" => body, "thumb" => message.thumb, "status" => "UNREAD", "event_type" => data.record.event_type })
              end
          end
      end
      {:noreply, :event_handled}
    else
      error -> {:stop, error, []}
    end
  end

  def handle_info(_, _state), do: {:noreply, :event_received}

end
