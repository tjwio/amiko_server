defmodule AmikoServer.Bump.Handler do
  @moduledoc false

  use GenServer

  alias AmikoServer.Bump.TempUserCoordinate

  def start_link() do
    GenServer.start_link(__MODULE__, %{}, name: __MODULE__)
  end

  def start_link(state) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  def start_link(state, opts) do
    GenServer.start_link(__MODULE__, state, opts)
  end

  def init(_opts) do
    {:ok, %{}}
  end

  def match_user(user_id, timestamp, ts_delta, latitude, longitude, radius) do
    GenServer.call(__MODULE__, {:match_user, user_id, timestamp, ts_delta, latitude, longitude, radius})
  end

  def handle_call({:match_user, user_id, timestamp, ts_delta, latitude, longitude, radius}, _from, users) do
    matched_user =
      Enum.find(users, fn {_temp_id, temp_user} ->
        cond do
          Kernel.abs(timestamp - temp_user.timestamp) <= ts_delta && Geocalc.distance_between([latitude, longitude], [temp_user.latitude, temp_user.longitude]) <= ((radius+temp_user.radius)*2) ->
            true
          true -> false
        end
      end)

    case matched_user do
      nil ->
        users = Map.put(users, user_id, %TempUserCoordinate{user_id: user_id, timestamp: timestamp, latitude: latitude, longitude: longitude, radius: radius})
        {:reply, {:ok, nil}, users}
      {matched_id, _} ->
        IO.inspect "matched " <> user_id <> " with " <> matched_id
        {:reply, {:ok, matched_id}, users}
    end
  end

end
