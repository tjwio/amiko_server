defmodule AmikoServerWeb.UserController do
  use AmikoServerWeb, :controller

  alias AmikoServer.Repo
  alias AmikoServer.Accounts
  alias AmikoServer.Accounts.User
  alias AmikoServer.Connections
  alias AmikoServer.Connections.History

  action_fallback AmikoServerWeb.FallbackController

  ### AUTH ###

  def signup(conn, user_params) do
    case Accounts.create_user(user_params) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = AmikoServer.Authentication.Guardian.encode_and_sign(user, %{}, permissions: %{user: []})
        conn
        |> send_resp(200, Poison.encode!(%{token: jwt, user: user}))
      {:error, _changeset} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to create user"}))
    end
  end

  def login(conn, %{"email" => email, "password" => password}) do
    case Accounts.get_authenticated_user(email, password) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = AmikoServer.Authentication.Guardian.encode_and_sign(user, %{}, permissions: %{user: []})
        conn
        |> send_resp(200, Poison.encode!(%{token: jwt, user: user}))
      {:error, reason} ->
        conn
        |> send_resp(401, Poison.encode!(%{message: "Invalid email or password"}))
    end
  end

  ### USER ###

  def show(conn, _params) do
    user = AmikoServer.Authentication.Guardian.Plug.current_resource(conn)

    conn
    |> send_resp(200, Poison.encode!(user))
  end

  def show_specific(conn, %{"id" => id}) do
    case Accounts.get_user(id) do
      user ->
        conn
        |> send_resp(200, Poison.encode!(user))
      _ ->
        conn
        |> send_resp(404, Poison.encode!%{})
    end
  end

  def get_connections(conn, _params) do
    user = AmikoServer.Authentication.Guardian.Plug.current_resource(conn)

    user = Repo.preload user, :history

    history = Repo.preload user.history, :added_user

    conn
    |> send_resp(200, Poison.encode!(history))
  end

  def update_user(conn, params) do
    user = AmikoServer.Authentication.Guardian.Plug.current_resource(conn)

    case Accounts.update_user(user, params) do
      {:ok, struct} ->
        conn
        |> send_resp(200, Poison.encode!(struct))
      {:error, _changeset} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to update user"}))
    end
  end

  ### HISTORY ###

  def add_connection(conn, %{"latitude" => latitude, "longitude" => longitude, "user_id" => added_user_id}) do
    user = AmikoServer.Authentication.Guardian.Plug.current_resource(conn)

    case add_connection_helper(user.id, latitude, longitude, added_user_id) do
      {:ok, history} ->
        conn
        |> send_resp(200, Poison.encode!(history))
      {:error, _changeset} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to add connection"}))
    end
  end

  def add_connection(conn, %{"latitude" => latitude, "longitude" => longitude, "users" => added_users}) do
    user = AmikoServer.Authentication.Guardian.Plug.current_resource(conn)

    case add_multiple_connections(user.id, latitude, longitude, [], added_users) do
      {:ok, added_users} ->
        conn
        |> send_resp(200, Poison.encode!(%{history: added_users}))
      {:error, _changeset} ->
        conn
        |> send_resp(400, Poison.encode!(%{message: "Failed to add connection"}))
    end
  end

  def delete_connection(conn, %{"id" => history_id}) do
    user = AmikoServer.Authentication.Guardian.Plug.current_resource(conn)

    case Connections.get_history(history_id) do
      history ->
        cond do
          history.user_id == user.id ->
            case Connections.delete_history(history) do
              {:ok, _} -> send_resp(conn, 200, Poison.encode!%{})
              {:error, _} -> send_resp(conn, 404, Poison.encode!%{})
            end
          true ->
            send_resp(conn, 403, Poison.encode!%{})
        end
      _ ->
        send_resp(conn, 404, Poison.encode!%{})
    end
  end

  defp add_connection_helper(user_id, latitude, longitude, added_user_id) do
    changeset = History.changeset(%History{}, %{latitude: latitude, longitude: longitude, added_user_id: added_user_id, user_id: user_id})

    case Repo.insert(changeset) do
      {:ok, history} ->
        history = Repo.preload(history, [:added_user])

        {:ok, history}
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp add_multiple_connections(user_id, latitude, longitude, added_users, [head | tail]) do
    case add_connection_helper(user_id, latitude, longitude, head) do
      {:ok, history} ->
        add_multiple_connections(user_id, latitude, longitude, [history | added_users], tail)
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  defp add_multiple_connections(_user_id, _latitude, _longitude, added_users, []) do
    {:ok, added_users}
  end
end
