defmodule AmikoServer.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :last_name, :string
      add :email, :string
      add :phone, :string
      add :image_url, :string
      add :profession, :string
      add :company, :string
      add :website, :string
      add :facebook, :string
      add :instagram, :string
      add :linkedin, :string
      add :twitter, :string
      add :password_hash, :string

      timestamps()
    end

  end
end
