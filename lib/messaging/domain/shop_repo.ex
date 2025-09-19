defmodule Messaging.ShopRepo do
  import Ecto.Query, warn: false
  alias Messaging.Repo
  alias Messaging.Shop
  alias Messaging.User
  alias Messaging.MessageToken

  def list_shops do
    Repo.all(Shop)
  end

  def all_shops_by_country_iso_code(country_iso_code) do
    query = from shop in Shop,
      join: user in User, on: shop.user_id == user.id,
      join: token in MessageToken, on: user.id == token.user_id,
      where: user.country_iso_code == ^country_iso_code,
      select: %{ id: shop.id, phone: user.phone, shop_name: shop.shop_name, token: token.fcm_token }
    Repo.all(query)
  end

  def get_shop(shop_id) do
    query = from shop in Shop,
      join: user in User, on: shop.user_id == user.id,
      where: shop.id == ^shop_id,
      select: %{ id: shop.id, userId: user.id, langCd: user.country_iso_code }
    Repo.one(query)
  end

  def create_shop(attrs \\ %{}) do
    %Shop{}
    |> Shop.changeset(attrs)
    |> Repo.insert()
  end

  def update_shop(%Shop{} = shop, attrs) do
    shop
    |> Shop.changeset(attrs)
    |> Repo.update()
  end

  def delete_shop(%Shop{} = shop) do
    Repo.delete(shop)
  end

  def change_shop(%Shop{} = shop, attrs \\ %{}) do
    Shop.changeset(shop, attrs)
  end

end
