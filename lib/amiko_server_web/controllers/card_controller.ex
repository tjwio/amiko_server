defmodule AmikoServerWeb.CardController do
  use AmikoServerWeb, :controller

  alias AmikoServer.{Accounts, Accounts.User, Authentication.Guardian, Connections, Repo}

  action_fallback AmikoServerWeb.FallbackController

  def get_cards(conn, _params) do
    user = Guardian.Plug.current_resource(conn)
    user = Repo.preload(user, :cards)

    conn
    |> send_resp(200, Poison.encode!(user.cards))
  end

  def get_public_card(conn, %{"id" => id}) do
    user = Guardian.Plug.current_resource(conn)
    card = Accounts.get_card!(id)
    card = Repo.preload(card, :user)

    user_map = User.default_public_map(card.user)

    user_map = Map.put(user_map, :mutual_friends, Connections.get_mutual_friends(user.id, card.user.id))

    conn
    |> send_resp(200, Poison.encode!(user_map))
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
