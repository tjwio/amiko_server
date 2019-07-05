defmodule AmikoServer.Connections.Ship do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, except: [:__meta__, :from_user, :to_user]}

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "ships" do
    field :latitude, :float
    field :longitude, :float
    field :pending, :boolean, default: true
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

  defimpl Poison.Encoder, for: AmikoServer.Connections.Ship do
    def encode(ship, options) do
      user_map = %{
        first_name: ship.from_user.first_name,
        last_name: ship.from_user.last_name,
        company: ship.from_user.company,
        profession: ship.from_user.profession,
      }

      user_map = Map.merge(user_map, parse_shared_info(ship.from_user, ship.shared_info, %{}))

      Poison.Encoder.Map.encode(%{latitude: ship.latitude, longitude: ship.longitude, inserted_at: ship.inserted_at, user: user_map}, options)
    end

    defp parse_shared_info(user, [head | tail], info_map) do
      key = String.to_atom(head)

      next_map = Map.put(info_map, key, Map.get(user, key))

      parse_shared_info(user, tail, next_map)
    end

    defp parse_shared_info(_user, [], info_map) do
      info_map
    end
  end
end
