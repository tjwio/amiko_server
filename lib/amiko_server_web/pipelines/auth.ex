defmodule AmikoServerWeb.Pipelines.Auth do
  @moduledoc false

  @claims %{typ: "access"}

  use Guardian.Plug.Pipeline,
      otp_app: :amiko_server,
      module: AmikoServer.Authentication.Guardian,
      error_handler: AmikoServer.Authentication.ErrorHandler

  plug(Guardian.Plug.VerifySession, claims: @claims)
  plug(Guardian.Plug.VerifyHeader, claims: @claims, realm: "Bearer")
  plug(Guardian.Plug.EnsureAuthenticated)
  plug(Guardian.Plug.LoadResource, ensure: true)

end
