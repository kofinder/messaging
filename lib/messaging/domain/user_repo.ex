defmodule Messaging.UserRepo do
  import Ecto.Query, warn: false
  alias Messaging.Repo
  alias Messaging.User

  def all_users_by_country_iso_code(country_iso_code) do
    query = from u in User,
        join: s in assoc(u, :shop),
        where: u.country_iso_code == ^country_iso_code,
        preload: [shop: s]
    Repo.all(query)
  end


  def get_user!(user_id), do: Repo.get!(User, user_id)

end
