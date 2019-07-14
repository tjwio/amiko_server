defmodule AmikoServer.Connections do
  @moduledoc """
  The Connections context.
  """

  import Ecto.Query, warn: false
  alias AmikoServer.{Connections.History, Repo, Accounts.User}

  @doc """
  Returns the list of history.

  ## Examples

      iex> list_history()
      [%History{}, ...]

  """
  def list_history do
    Repo.all(History)
  end

  @doc """
  Gets a single history.

  Raises `Ecto.NoResultsError` if the History does not exist.

  ## Examples

      iex> get_history!(123)
      %History{}

      iex> get_history!(456)
      ** (Ecto.NoResultsError)

  """
  def get_history!(id), do: Repo.get!(History, id)

  def get_history(id), do: Repo.get(History, id)

  @doc """
  Creates a history.

  ## Examples

      iex> create_history(%{field: value})
      {:ok, %History{}}

      iex> create_history(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_history(attrs \\ %{}) do
    %History{}
    |> History.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a history.

  ## Examples

      iex> update_history(history, %{field: new_value})
      {:ok, %History{}}

      iex> update_history(history, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_history(%History{} = history, attrs) do
    history
    |> History.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a History.

  ## Examples

      iex> delete_history(history)
      {:ok, %History{}}

      iex> delete_history(history)
      {:error, %Ecto.Changeset{}}

  """
  def delete_history(%History{} = history) do
    Repo.delete(history)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking history changes.

  ## Examples

      iex> change_history(history)
      %Ecto.Changeset{source: %History{}}

  """
  def change_history(%History{} = history) do
    History.changeset(history, %{})
  end

  alias AmikoServer.Connections.Ship

  @doc """
  Returns the list of ships.

  ## Examples

      iex> list_ships()
      [%Ship{}, ...]

  """
  def list_ships do
    Repo.all(Ship)
  end

  @doc """
  Gets a single ship.

  Raises `Ecto.NoResultsError` if the Ship does not exist.

  ## Examples

      iex> get_ship!(123)
      %Ship{}

      iex> get_ship!(456)
      ** (Ecto.NoResultsError)

  """
  def get_ship!(id), do: Repo.get!(Ship, id)

  def get_ship(from_user_id, to_user_id) do
    Ship
    |> Repo.get_by([from_user_id: from_user_id, to_user_id: to_user_id])
  end

  def get_ship!(from_user_id, to_user_id) do
    Ship
    |> Repo.get_by!([from_user_id: from_user_id, to_user_id: to_user_id])
  end

  def get_mutual_friends(curr_id, match_id) do
    ship_query =
      from s in Ship,
      where: s.from_user_id == ^match_id

    from_user_query =
      from u in User,
      preload: [ships: ^ship_query]

    query = from s in Ship,
            where: s.to_user_id == ^curr_id and not s.pending,
            preload: [from_user: ^from_user_query]

    ships = Repo.all(query)

    ships
    |> Enum.filter(fn ship -> not Enum.empty?(ship.from_user.ships) end)
    |> Enum.map(fn ship -> User.default_public_map(ship.from_user) end)
  end

  @doc """
  Creates a ship.

  ## Examples

      iex> create_ship(%{field: value})
      {:ok, %Ship{}}

      iex> create_ship(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_ship(attrs \\ %{}) do
    %Ship{}
    |> Ship.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a ship.

  ## Examples

      iex> update_ship(ship, %{field: new_value})
      {:ok, %Ship{}}

      iex> update_ship(ship, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_ship(%Ship{} = ship, attrs) do
    ship
    |> Ship.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Ship.

  ## Examples

      iex> delete_ship(ship)
      {:ok, %Ship{}}

      iex> delete_ship(ship)
      {:error, %Ecto.Changeset{}}

  """
  def delete_ship(%Ship{} = ship) do
    Repo.delete(ship)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking ship changes.

  ## Examples

      iex> change_ship(ship)
      %Ecto.Changeset{source: %Ship{}}

  """
  def change_ship(%Ship{} = ship) do
    Ship.changeset(ship, %{})
  end
end
