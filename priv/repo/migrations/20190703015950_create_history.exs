defmodule AmikoServer.Repo.Migrations.CreateHistory do
  use Ecto.Migration

  def change do
    create table(:history, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :latitude, :float
      add :longitude, :float
      add :user_id, references(:users, type: :binary_id, on_delete: :nothing)
      add :added_user_id, references(:users, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:history, [:user_id])
    create index(:history, [:added_user_id])
  end
end
