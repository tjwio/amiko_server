defmodule AmikoServerWeb.ShipController do
  use AmikoServerWeb, :controller

  alias AmikoServer.{Authentication.Guardian, Connections, Repo}

  action_fallback AmikoServerWeb.FallbackController

  def get_ships(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    user = Repo.preload(user, [:ships, ships: :from_user])

    conn
    |> send_resp(200, Poison.encode!(user.ships))
  end

  def add_ship(conn, %{"from_user_id" => from_user_id, "to_user_id" => to_user_id} = params) do
    user = Guardian.Plug.current_resource(conn)

    case Connections.get_ship(from_user_id, to_user_id) do
      ship ->
        Connections.update_ship(ship, %{pending: false})
        params = %{params | pending: false}
    end

    case Connections.create_ship(params) do
      {:ok, new_ship} ->
        conn
        |> send_resp(200, Poison.encode!(new_ship))
      {:error, _changeset} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to create ship"}))
    end
  end

end
