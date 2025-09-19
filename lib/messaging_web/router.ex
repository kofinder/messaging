defmodule MessagingWeb.Router do
  use MessagingWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api/v1.0/", MessagingWeb do
    pipe_through :api

    get "/initialize", NotificationController, :initializeNotification
    get "/notifications", NotificationController, :allNotifications
    get "/check_status", NotificationController, :checkNotificationStatus

    put "/read_all_notifications/:userId", NotificationController, :readAllNotifications
    put "/read_notification/:messageId", NotificationController, :readNotification

    post "/create_token", NotificationController, :createToken
    post "/send/:token", NotificationController, :send
    post "/send_all", NotificationController, :sendAll

    post "/send_geographic_campaign_notification", NotificationController, :sendGeographicCampaignNotification
  end

  scope "/swagger" do
    forward "/", PhoenixSwagger.Plug.SwaggerUI, otp_app: :messaging, swagger_file: "swagger.json"
  end

  @spec swagger_info :: %{info: %{title: <<_::176>>, version: <<_::24>>}}
  def swagger_info do
    %{
      info: %{ version: "1.0", title: "mnp messaging platform" }
    }
  end

end
