defmodule AmikoServer.Repo do
  use Ecto.Repo,
    otp_app: :amiko_server,
    adapter: Ecto.Adapters.Postgres
end
