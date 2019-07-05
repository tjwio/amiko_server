defmodule AmikoServer.Connections.Ship do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, except: [:__meta__, :from_user, :to_user]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "ships" do
    field :latitude, :float
    field :longitude, :float
    field :shared_info, {:array, :string}, default: []
    belongs_to :from_user, AmikoServer.Accounts.User, foreign_key: :from_user_id
    belongs_to :to_user, AmikoServer.Accounts.User, foreign_key: :to_user_id

    timestamps()
  end

  @doc false
  def changeset(ship, attrs) do
    ship
    |> cast(attrs, [:latitude, :longitude, :shared_info, :from_user_id, :to_user_id])
    |> validate_required([:latitude, :longitude, :shared_info, :from_user_id, :to_user_id])
    |> assoc_constraint(:to_user)
    |> assoc_constraint(:from_user)
    |> unique_constraint(:to_user, name: :user_ship_index)
  end
end
