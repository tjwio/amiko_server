defmodule AmikoServer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  alias AmikoServer.Repo

  @derive {Poison.Encoder, except: [:__meta__, :password, :password_hash, :cards, :history, :ships]}

  @primary_key {:id, :binary_id, autogenerate: true}

  schema "users" do
    field :company, :string
    field :email, :string
    field :facebook, :string
    field :first_name, :string
    field :image_url, :string
    field :instagram, :string
    field :last_name, :string
    field :linkedin, :string
    field :password, :string, virtual: true
    field :password_hash, :string
    field :phone, :string
    field :profession, :string
    field :twitter, :string
    field :website, :string

    has_many :cards, AmikoServer.Accounts.Card, foreign_key: :user_id
    has_many :history, AmikoServer.Connections.History, foreign_key: :user_id
    has_many :ships, AmikoServer.Connections.Ship, foreign_key: :to_user_id

    timestamps()
  end

  def find_and_confirm_password(email, password) do
    case Repo.get_by(User, email: email) do
      nil ->
        {:error, :not_found}
      user ->
        if Comeonin.Bcrypt.checkpw(password, user.password_hash) do
          {:ok, user}
        else
          {:error, :unauthorized}
        end
    end
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :phone, :image_url, :profession, :company, :website, :facebook, :instagram, :linkedin, :twitter])
    |> validate_required([:first_name, :last_name, :email, :phone])
    |> validate_email
  end

  def registration_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:first_name, :last_name, :email, :phone, :image_url, :profession, :company, :website, :facebook, :instagram, :linkedin, :twitter, :password])
    |> validate_required([:first_name, :last_name, :email, :phone, :password])
    |> validate_changeset
  end

  def image_changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:image_url])
  end

  defp validate_changeset(struct) do
    struct
    |> validate_email
    |> validate_password
  end

  defp validate_email(struct) do
    struct
    |> validate_length(:email, min: 5, max: 255)
    |> validate_format(:email, ~r/@/)
    |> unique_constraint(:email)
  end

  defp validate_password(struct) do
    struct
    |> validate_length(:password, min: 6)
      #    |> validate_format(:password, ~r/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).*/, [message: "Must include at least one lowercase letter, one uppercase letter, and one digit"])
    |> generate_password_hash
  end

  defp generate_password_hash(changeset) do
    case changeset do
      %Ecto.Changeset{valid?: true, changes: %{password: password}} ->
        put_change(changeset, :password_hash, Comeonin.Bcrypt.hashpwsalt(password))
      _ ->
        changeset
    end
  end
end
