defmodule AmikoServer.Connections.History do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, except: [:__meta__, :user]}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "history" do
    field :latitude, :float
    field :longitude, :float
    belongs_to :user, AmikoServer.Accounts.User, foreign_key: :user_id
    belongs_to :added_user, AmikoServer.Accounts.User, foreign_key: :added_user_id

    timestamps()
  end

  @doc false
  def changeset(history, attrs) do
    history
    |> cast(attrs, [:latitude, :longitude, :user_id, :added_user_id])
    |> validate_required([:latitude, :longitude, :user_id, :added_user_id])
    |> assoc_constraint(:user)
    |> assoc_constraint(:added_user)
  end
end
