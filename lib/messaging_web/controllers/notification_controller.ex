defmodule MessagingWeb.NotificationController do
  use MessagingWeb, :controller
  use PhoenixSwagger
  require Logger

  alias Messaging.MessageToken
  alias Messaging.MessageTokenRepo
  alias Messaging.MessageHistoryRepo
  alias Messaging.ShopNotificationRepo
  action_fallback MessagingWeb.FallbackController

  def swagger_definitions do
    %{
      NotificationRequest: swagger_schema do
        title("NotificationRequest")
        description("POST body for creating a notification")
        properties do
          title :string, "firebase refresh token", required: true
          body :string, "firebase refresh token", required: true
          thumb :string, "firebase refresh token", required: true
          status :string, "firebase refresh token", required: true
        end
        example(%{
          title: "Out of Stock",
          body: "There are items out of stock. Please refill them now!",
          thumb: "assets/865397d3-2ff4-484a-93c6-355a8c5ea34b-medicine.png",
          status: "UNREAD",
        })
      end,

      NotificationResponse: swagger_schema do
        title("NotificationResponse")
        description("Response schema for single notification")
        properties do
          id :string, "Token ID", format: Ecto.UUID
          shopId :string, "shop owner id", required: true, format: Ecto.UUID
          title :string, "notification message title", required: true
          body :string, "notification message body", required: true
          thumb :string, "notification message icon/image", required: false
          status :string, "notification message status (read/unread)", required: true
          createdAt :string, "Creation timestamp", format: :datetime
          updatedAt :string, "Update timestamp", format: :datetime
        end
        example(%{
          id: "0c56ff53-9c7d-4764-91e0-d3a117dc12a2",
          title: "Out of Stock",
          body: "There are items out of stock. Please refill them now!",
          thumb: "assets/865397d3-2ff4-484a-93c6-355a8c5ea34b-medicine.png",
          status: "UNREAD",
          shopId: "3e7ce46b-7b92-48ff-a54e-d6cdb30201cc",
          createdAt: "2023-05-15T03:29:33",
          updatedAt: "2023-05-15T03:29:33"
        })
      end,

      CampaignNotificationRequest: swagger_schema do
        title("GeoGraphic Campaign Notification")
        description("Request Body for GeoGraphic Campaign Notification")
        properties do
          countryISOCode :string, "Specific Country ISO Code", required: true
          title :string, "Message Title", required: true
          body :string, "Message Body", required: true
          thumb :string, "Message Icon", required: true
          status :string, "Message status", required: true
        end
        example(%{
          countryISOCode: "MM",
          title: "Out of Stock",
          body: "There are items out of stock. Please refill them now!",
          thumb: "assets/865397d3-2ff4-484a-93c6-355a8c5ea34b-medicine.png",
          status: "UNREAD"
        })
      end,

      TokenRequest: swagger_schema do
        title "TokenRequest"
        description "POST body for creating token request"
        properties do
          userId :string, "User ID", required: true, format: Ecto.UUID
          platform :string, "firebase refresh token", required: true
          permission :string, "firebase refresh token", required: true
          token :string, "firebase refresh token", required: true
        end
        example(%{
          userId: "1a38da49-3fc6-4ebe-8f6b-dc562a096cbf",
          token: "e8QgR6PISQepoPSnV4ZrDg:APA91bEp3nBGrUPFtg-AJX_D9_7QsgE0uHnJhwmSqQztdacJimAW6tC38d1xaSfLQpMdjvg6kyCE2j57xQrZ7bBCs8Be9QgHiL-TEeQtwG4wo_HtmXBgsn-zgIsoF7eA8jW8_X-ddNk7",
          platform: "android",
          permission: "Authorized",
          createdAt: "2023-05-15T03:29:33",
          updatedAt: "2023-05-15T03:29:33"
        })
      end,

      TokenResponse: swagger_schema do
        title("TokenResponse")
        description("A user of the app")
        properties do
          id :string, "Token ID", format: Ecto.UUID
          userId :string, "User ID", required: true, format: Ecto.UUID
          token :string, "firebase refresh token", required: true
          createdAt :string, "Creation timestamp", format: :datetime
          updatedAt :string, "Update timestamp", format: :datetime
        end
      end,

      CommandResponse: swagger_schema do
        title("CommandResponse")
        description("A user of the app")
        properties do
          id :string, "ID", format: Ecto.UUID
          message :string
          isUpdated :boolean
        end
      end,

      NotificationStausResponse: swagger_schema do
        title("NotificationStausResponse")
        properties do
          unRead :number
        end
      end,

      Error: swagger_schema do
        title "Errors"
        description "Error responses from the API"
        properties do
          error :string, "The message of the error raised", required: true
        end
      end
    }
  end

  swagger_path :initializeNotification do
    get "/api/v1.0/initialize"
    summary "Create Message for All Shops "
    description "Creates Message"
    response 200, "OK", Schema.ref(:CommandResponse)
    response 400, "Client Error", Schema.ref(:Error)
  end
  def initializeNotification(conn, _params) do
    shop = Messaging.ShopRepo.list_shops()
    Enum.each(shop, fn(s) -> ShopNotificationRepo.create_notification(s) end)
    command = %{ "id" => "0c56ff53-9c7d-4764-91e0-d3a117dc12a2", "message" => 'success', "isUpdated" => true }
    conn |> put_status(:created) |> render(:commandJson, command: command)
  end

  swagger_path :allNotifications do
    get "/api/v1.0/notifications"
    summary "List Notifications"
    description "List all notifications in the database"
    consumes "application/json"
    produces "application/json"
    parameters do
      userId :query, :string, "User ID", required: true, format: Ecto.UUID, default: "1a38da49-3fc6-4ebe-8f6b-dc562a096cbf"
      sort_by :query, :string, "The property to sort by", default: "title"
      sort_direction :query, :string, "The sort direction", required: true, enum: [:asc, :desc], default: :asc
      limit :query, :integer, "The sort direction", default: 20, required: true
      skip :query, :integer, "The sort direction", default: 0, required: true
    end
    response 200, "OK", Schema.ref(:NotificationResponse)
    response 400, "Client Error", Schema.ref(:Error)
  end
  def allNotifications(conn, params) do
    messages = MessageHistoryRepo.list_all_message_with_pagianation(params)
    render(conn, :notificationJson, notifications: messages)
  end

  swagger_path :checkNotificationStatus do
    get "/api/v1.0/check_status"
    summary "Check Notification Status"
    consumes "application/json"
    produces "application/json"
    parameters do
      userId :query, :string, "User ID", required: true, format: Ecto.UUID, default: "1a38da49-3fc6-4ebe-8f6b-dc562a096cbf"
    end
    response 200, "OK", Schema.ref(:NotificationStausResponse)
    response 400, "Client Error", Schema.ref(:Error)
  end
  def checkNotificationStatus(conn, params) do
    unreadCount = MessageHistoryRepo.get_unread_count(params)
    render(conn, :statusJson, status: %{ unRead: unreadCount })
  end

  swagger_path :readAllNotifications do
    put "/api/v1.0/read_all_notifications/{userId}"
    summary "Read All Notifications"
    description "Update All Notification message in the database"
    consumes "application/json"
    produces "application/json"
    parameter :userId, :path, :string, "User ID", required: true, format: Ecto.UUID, default: "1a38da49-3fc6-4ebe-8f6b-dc562a096cbf"
    response 200, "OK", Schema.ref(:CommandResponse)
    response 400, "Client Error", Schema.ref(:Error)
  end
  def readAllNotifications(conn, %{"userId" => userId}) do
    MessageHistoryRepo.update_all_messages_status(userId)
    command = %{ "id" => userId, "message" => "success", "isUpdated" => true }
    conn |> put_status(:created) |> render(:commandJson, command: command)
  end

  swagger_path :readNotification do
    put "/api/v1.0/read_notification/{messageId}"
    summary "Read Each Notification"
    description "Update Notification message in the database"
    consumes "application/json"
    produces "application/json"
    parameter :messageId, :path, :string, "Message ID", required: true, format: Ecto.UUID, default: "0c56ff53-9c7d-4764-91e0-d3a117dc12a2"
    response 200, "OK", Schema.ref(:CommandResponse)
    response 400, "Client Error", Schema.ref(:Error)
  end
  def readNotification(conn, %{"messageId" => messageId}) do
    MessageHistoryRepo.update_message_status(messageId)
    command = %{ "id" => messageId, "message" => "success", "isUpdated" => true }
    conn |> put_status(:created) |> render(:commandJson, command: command)
  end

  swagger_path :createToken do
    post "/api/v1.0/create_token"
    summary "Create FCM Token"
    description "Creates a new token"
    consumes "application/json"
    produces "application/json"
    parameter :token, :body, Schema.ref(:TokenRequest), "Token Request"
    response 200, "OK", Schema.ref(:TokenResponse)
    response 400, "Client Error", Schema.ref(:Error)
  end
  def createToken(conn, %{"userId" => userId, "platform" => platform, "permission" => permission, "token" => fcmToken}) do
    case MessageTokenRepo.get_message_token(userId) do
      nil ->
        {:ok, %MessageToken{} = user} = MessageTokenRepo.create_token(%{user_id: userId, platform: platform, permission: permission, fcm_token: fcmToken })
        conn |> put_status(:created) |> render(:toJson, token: user)
      result ->
        {:ok, %MessageToken{} = user}  = MessageTokenRepo.update_token(result, %{platform: platform, permission: permission, fcm_token: fcmToken})
        conn |> put_status(:created) |> render(:toJson, token: user)
    end
  end

  swagger_path :send do
    post "/api/v1.0/send/{token}"
    summary "Sending Notification"
    description "Send Notification to User Directly"
    consumes "application/json"
    produces "application/json"
    parameter :token, :path, :string, "FCM Token", required: true, default: "dx4Y5_-UTMudBf3FXGCJSQ:APA91bGDQeHnMGo03PgajOOojhMPx4m4INs4XSm0D0Ht32lXjKwBnw-AmF7oGFzR2THCtRJmp13W0oCEMLAK106ItMOIT9TTfEm3_-EbPg2knuo_qkCYvBV74sslKI5746Aly3yfBE5r"
    parameter :message, :body, Schema.ref(:NotificationRequest), "Notification Request"
    response 200, "OK", Schema.ref(:NotificationResponse)
    response 400, "Client Error", Schema.ref(:Error)
  end
  def send(conn, %{"token" => token, "title" => title, "body" => body}) do
    n = Pigeon.FCM.Notification.new({:token, token}, %{"title" => title, "body" => body})
    Messaging.FCM.push(n)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, "Notification message sent successfully!")
  end

  swagger_path :sendAll do
    post "/api/v1.0/send_all"
    summary "Sending Notificatiosn"
    description "Send Notification to All Users"
    consumes "application/json"
    produces "application/json"
    parameter :message, :body, Schema.ref(:NotificationRequest), "Notification Request"
    response 200, "OK", Schema.ref(:NotificationResponse)
    response 400, "Client Error", Schema.ref(:Error)
  end
  def sendAll(conn, %{"title" => title, "body" => body}) do
    n = Pigeon.FCM.Notification.new({:topic, "momnpop"}, %{"title" => title, "body" => body})
    Messaging.FCM.push(n)
    conn
    |> put_resp_content_type("application/json")
    |> send_resp(200, "Notification message sent successfully!")
  end

  swagger_path :sendGeographicCampaignNotification do
    post "/api/v1.0/send_geographic_campaign_notification"
    summary "Sending Geographic Campaign Notificatiosn"
    description "Send Notification to Users by usining specific country"
    consumes "application/json"
    produces "application/json"
    parameter :message, :body, Schema.ref(:CampaignNotificationRequest), "Campaign Notification Request"
    response 200, "OK", Schema.ref(:CommandResponse)
    response 400, "Client Error", Schema.ref(:Error)
  end
  def sendGeographicCampaignNotification(conn, %{"countryISOCode" => countryISOCode, "title" => title, "body" => body}) do
    users = Messaging.ShopRepo.all_shops_by_country_iso_code(countryISOCode);
    Enum.each(users, fn(usr) ->
      n = Pigeon.FCM.Notification.new({:token, usr.token}, %{"title" => title, "body" => body})
      Messaging.FCM.push(n)
    end)
    command = %{ "id" => '', "message" => "success", "isUpdated" => true }
    conn |> put_status(:created) |> render(:commandJson, command: command)
  end

end
