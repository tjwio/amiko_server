defmodule AmikoServerWeb.CardController do
  use AmikoServerWeb, :controller

  alias AmikoServer.{Accounts, Authentication.Guardian, Connections, Repo}

  action_fallback AmikoServerWeb.FallbackController

  def get_cards(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    user = Repo.preload(user, :cards)

    conn
    |> send_resp(200, Poison.encode!(user.cards))
  end

  def get_public_card(conn, %{"id" => id}) do
    card = Accounts.get_card!(id)
    card = Repo.preload(card, :user)

    conn
    |> send_resp(200, Poison.encode!(%{
      id: card.user.id,
      first_name: card.user.first_name,
      last_name: card.user.last_name,
      profession: card.user.profession,
      company: card.user.company,
      image_url: card.user.image_url }))
  end

end
