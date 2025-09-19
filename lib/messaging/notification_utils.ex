defmodule Messaging.NotificationUtils do

  @typedoc """
   conevert enum to string, e.g. 1984
   """
  @type eventType :: NotificationEventType


  # @spec convert_notification_title(eventType) :: String
  def convert_notification_title(eventType) do
    case eventType do
      "LOWONSTOCK" -> "Low on Stock"
      "OUTOFSTOCK" -> "Out of Stock"
      "SKUCHECKUP" -> "SKU Checkup"
      "NOLOADED" -> "No item in your inventory"
      "UNUSED" -> "Don't miss out!"
      "CLOSED" -> "Reconnect now!"
      "INSIGHT" -> "Insights"
      "DEMAND" -> "Demand increasing"
      _ -> "New Released"
    end
  end

  # @spec convert_notification_body(eventType) :: String
  def convert_notification_body(eventType) do
    case eventType do
      "LOWONSTOCK" -> "There are items low on stock. Please refill them now!"
      "OUTOFSTOCK" -> "There are items out of stock. Please order more!"
      "SKUCHECKUP" -> "You have items with incomplete information. Please update them now!"
      "NOLOADED" -> "You have no item in your inventory yet, scan an item’s barcode to get started"
      "UNUSED" -> "You haven't used Digital Shop in 24 hours. How can we help?"
      "CLOSED" -> "You haven't used Digital Shop in 7 days. How can we help?"
      "INSIGHT" -> "Your sale report is ready! View your sales trends and revenue growth."
      "DEMAND" -> "[Item Name] demand increasing, consider increasing stock"
      _ -> "Please update the app on play store"
    end
  end


  def convert_notification_thumb(eventType) do
    case eventType do
      "LOWONSTOCK" -> "low_on_stock.png"
      "OUTOFSTOCK" -> "out_of_stock.png"
      "SKUCHECKUP" -> "sku_check_up.png"
      "NOLOADED" -> "no_item.png"
      "UNUSED" -> "unused.png"
      "CLOSED" -> "reconnect.png"
      "INSIGHT" -> "insight.png"
      "DEMAND" -> "demand.png"
      _ -> "none_image.png"
    end
  end

end
