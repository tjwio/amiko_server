defmodule AmikoServer.Bump.TempUserCoordinate do
  @moduledoc false
  @enforce_keys [:user_id, :timestamp, :latitude, :longitude, :radius]
  defstruct [:user_id, :timestamp, :latitude, :longitude, :radius]
end