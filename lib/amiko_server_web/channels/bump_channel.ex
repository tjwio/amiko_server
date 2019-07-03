defmodule AmikoServerWeb.BumpChannel do
  use AmikoServerWeb, :channel

  alias AmikoServer.Accounts

  @timestamp_max_diff 50.0 # milliseconds
  @bump_matched_event "bump_matched"

  def join("bump:lobby", _payload, socket) do
    {:ok, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  def handle_in("bumped", %{"timestamp" => timestamp, "latitude" => latitude, "longitude" => longitude, "accuracy" => accuracy}, socket) do
    curr_user = Guardian.Phoenix.Socket.current_resource(socket)
    user_id = curr_user.id

    {:ok, closest_user_id} = AmikoServer.Bump.Handler.match_user(user_id, timestamp, @timestamp_max_diff, latitude, longitude, accuracy)

    if closest_user_id == nil do
      {:reply, :ok, socket}
    else
      IO.puts "matched " <> user_id <> " with " <> closest_user_id
      matched_user = Accounts.get_user(closest_user_id)
      unless curr_user == nil or matched_user == nil do
        AmikoServerWeb.Endpoint.broadcast("private_room:" <> user_id, @bump_matched_event, Poison.encode!(matched_user) |> Poison.Parser.parse!)
        AmikoServerWeb.Endpoint.broadcast("private_room:" <> closest_user_id, @bump_matched_event, Poison.encode!(curr_user) |> Poison.Parser.parse!)
      end

      {:noreply, socket}
    end
  end

  def handle_in("bump_test", %{"timestamp" => _timestamp, "latitude" => _latitude, "longitude" => _longitude}, socket) do
    curr_user = Guardian.Phoenix.Socket.current_resource(socket)
    AmikoServerWeb.Endpoint.broadcast("private_room:" <> curr_user.id, @bump_matched_event, Poison.encode!(curr_user) |> Poison.Parser.parse!)

    {:noreply, socket}
  end
end
