defmodule AmikoServerWeb.PrivateRoomChannel do
  use AmikoServerWeb, :channel

  def join("private_room:" <> user_id, _payload, socket) do
    user = Guardian.Phoenix.Socket.current_resource(socket)
    if user.id == user_id do
      {:ok, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end
end
