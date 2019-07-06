defmodule AmikoServer.Repo.Migrations.CreateCards do
  use Ecto.Migration

  def change do
    create table(:cards, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing)
      timestamps()
    end

    create index(:cards, [:user_id])
  end
end
