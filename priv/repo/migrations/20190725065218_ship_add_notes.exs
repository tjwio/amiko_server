defmodule AmikoServer.Repo.Migrations.ShipAddNotes do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :notes, :string
    end
  end
end
