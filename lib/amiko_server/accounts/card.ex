defmodule AmikoServer.Accounts.Card do
  use Ecto.Schema
  import Ecto.Changeset

  @derive {Poison.Encoder, except: [:__meta__, :user]}

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id

  schema "cards" do
    belongs_to :user, AmikoServer.Accounts.User, foreign_key: :user_id
    timestamps()
  end

  @doc false
  def changeset(card, attrs) do
    card
    |> cast(attrs, [:id, :user_id])
    |> validate_required([:id, :user_id])
    |> assoc_constraint(:user)
  end
end
