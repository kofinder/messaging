defmodule Messaging.ShopNotificationRepo do
  import Ecto.Query, warn: false
  alias Messaging.Repo
  alias Messaging.ShopNotification

  def create_notification(shop) do
    Repo.insert(%ShopNotification{
      event_type: "DEFAULT",
      shop: shop
    })
  end

end
