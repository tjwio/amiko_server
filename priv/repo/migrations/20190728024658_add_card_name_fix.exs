defmodule AmikoServer.Repo.Migrations.AddCardNameFix do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :name, :string
    end
  end
end
