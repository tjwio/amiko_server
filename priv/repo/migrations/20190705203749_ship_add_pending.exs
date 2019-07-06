defmodule AmikoServer.Repo.Migrations.ShipAddPending do
  use Ecto.Migration

  def change do
    alter table(:ships) do
      add :pending, :boolean
    end
  end
end
