defmodule AmikoServerWeb.ShipController do
  use AmikoServerWeb, :controller

  alias AmikoServer.{Authentication.Guardian, Connections, Repo}

  action_fallback AmikoServerWeb.FallbackController

  @ship_added_event "ship_added"

  def get_ships(conn, _params) do
    user = Guardian.Plug.current_resource(conn)

    user = Repo.preload(user, [:ships, ships: :from_user])

    conn
    |> send_resp(200, Poison.encode!(user.ships))
  end

  def get_specific_user_ship(conn, %{"user_id" => user_id}) do
    user = Guardian.Plug.current_resource(conn)
    ship = Connections.get_ship!(user.id, user_id)

    ship = Repo.preload(ship, :from_user)

    conn
    |> send_resp(200, Poison.encode!(ship))
  end

  def add_ship(conn, %{"to_user_id" => to_user_id} = params) do
    user = Guardian.Plug.current_resource(conn)
    from_user_id = user.id

    params = Map.put(params, "from_user_id", from_user_id)

    ship = Connections.get_ship(to_user_id, from_user_id)
    unless ship == nil do
      Connections.update_ship(ship, %{pending: false})
      add_ship_helper(conn, Map.put(params, "pending", false))
    else
      add_ship_helper(conn, params)
    end
  end

  def delete_ship(conn, %{"id" => ship_id}) do
    ship = Connections.get_ship!(ship_id)
    case Connections.delete_ship(ship) do
      {:ok, _} -> send_resp(conn, 200, Poison.encode!%{})
      {:error, _} -> send_resp(conn, 400, Poison.encode!%{})
    end
  end

  def update_ship(conn, %{"id" => ship_id} = params) do
    ship = Connections.get_ship!(ship_id)
    case Connections.update_ship(ship, params) do
      {:ok, new_ship} ->
        new_ship = Repo.preload(new_ship, :from_user)

        conn
        |> send_resp(200, Poison.encode!(new_ship))
      {:error, _changeset} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to update ship"}))
    end
  end

  defp add_ship_helper(conn, params) do
    case Connections.create_ship(params) do
      {:ok, new_ship} ->
        new_ship = Repo.preload(new_ship, :from_user)

        AmikoServerWeb.Endpoint.broadcast("private_room:" <> new_ship.to_user_id, @ship_added_event, Poison.encode!(new_ship) |> Poison.Parser.parse!)

        conn
        |> send_resp(200, Poison.encode!(new_ship))
      {:error, _changeset} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to create ship"}))
    end
  end

end
