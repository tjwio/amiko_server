defmodule AmikoServer.Authentication.ErrorHandler do
  @moduledoc false

  import Plug.Conn

  def auth_error(conn, {type, _reason}, _opts) do
    conn
    |> send_resp(401, Poison.encode!(%{message: to_string(type)}))
  end

end
