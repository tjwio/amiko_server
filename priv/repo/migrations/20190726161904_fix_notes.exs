defmodule AmikoServer.Repo.Migrations.FixNotes do
  use Ecto.Migration

  def change do
    alter table(:ships) do
      add :notes, :string
    end

    alter table(:users) do
      remove :notes
    end
  end
end
