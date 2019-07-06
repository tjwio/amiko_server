defmodule AmikoServerWeb.CardController do
  use AmikoServerWeb, :controller

  alias AmikoServer.{Accounts, Authentication.Guardian, Repo}

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

  def add_card(conn, params) do
    user = Guardian.Plug.current_resource(conn)
    params = Map.put(params, "user_id", user.id)

    case Accounts.create_card(params) do
      {:ok, card} ->
        conn
        |> send_resp(200, Poison.encode!(card))
      {:error, _changeset} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to create card"}))
    end
  end

end
