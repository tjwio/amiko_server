defmodule AmikoServer.Repo.Migrations.CreateShips do
  use Ecto.Migration

  def change do
    create table(:ships, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :latitude, :float
      add :longitude, :float
      add :shared_info, {:array, :string}
      add :from_user_id, references(:users, type: :binary_id, on_delete: :nothing)
      add :to_user_id, references(:users, type: :binary_id, on_delete: :nothing)

      timestamps()
    end

    create index(:ships, [:from_user_id])
    create index(:ships, [:to_user_id])
    create unique_index(:ships, [:from_user_id, :to_user_id], name: :user_ship_index)
  end
end
