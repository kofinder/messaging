defmodule Messaging.MessageTemplateRepo do
  import Ecto.Query, warn: false
  alias Messaging.Repo
  alias Messaging.MessageTemplate


  def get_message_template(lang_cd, event_type) do
    query = from t in MessageTemplate,
    where: t.lang_cd == ^lang_cd and t.event_type == ^event_type,
    select: %{id: t.id, title: t.title, body: t.body, thumb: t.thumb }
    Repo.one(query)
  end

end
