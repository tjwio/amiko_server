defmodule AmikoServer.Repo.Migrations.UsersAddBio do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :bio, :string
    end
  end
end
