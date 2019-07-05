defmodule AmikoServer.ConnectionsTest do
  use AmikoServer.DataCase

  alias AmikoServer.Connections

  describe "history" do
    alias AmikoServer.Connections.History

    @valid_attrs %{latitude: 120.5, longitude: 120.5}
    @update_attrs %{latitude: 456.7, longitude: 456.7}
    @invalid_attrs %{latitude: nil, longitude: nil}

    def history_fixture(attrs \\ %{}) do
      {:ok, history} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Connections.create_history()

      history
    end

    test "list_history/0 returns all history" do
      history = history_fixture()
      assert Connections.list_history() == [history]
    end

    test "get_history!/1 returns the history with given id" do
      history = history_fixture()
      assert Connections.get_history!(history.id) == history
    end

    test "create_history/1 with valid data creates a history" do
      assert {:ok, %History{} = history} = Connections.create_history(@valid_attrs)
      assert history.latitude == 120.5
      assert history.longitude == 120.5
    end

    test "create_history/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Connections.create_history(@invalid_attrs)
    end

    test "update_history/2 with valid data updates the history" do
      history = history_fixture()
      assert {:ok, %History{} = history} = Connections.update_history(history, @update_attrs)
      assert history.latitude == 456.7
      assert history.longitude == 456.7
    end

    test "update_history/2 with invalid data returns error changeset" do
      history = history_fixture()
      assert {:error, %Ecto.Changeset{}} = Connections.update_history(history, @invalid_attrs)
      assert history == Connections.get_history!(history.id)
    end

    test "delete_history/1 deletes the history" do
      history = history_fixture()
      assert {:ok, %History{}} = Connections.delete_history(history)
      assert_raise Ecto.NoResultsError, fn -> Connections.get_history!(history.id) end
    end

    test "change_history/1 returns a history changeset" do
      history = history_fixture()
      assert %Ecto.Changeset{} = Connections.change_history(history)
    end
  end

  describe "ships" do
    alias AmikoServer.Connections.Ship

    @valid_attrs %{latitude: 120.5, longitude: 120.5, shared_info: []}
    @update_attrs %{latitude: 456.7, longitude: 456.7, shared_info: []}
    @invalid_attrs %{latitude: nil, longitude: nil, shared_info: nil}

    def ship_fixture(attrs \\ %{}) do
      {:ok, ship} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Connections.create_ship()

      ship
    end

    test "list_ships/0 returns all ships" do
      ship = ship_fixture()
      assert Connections.list_ships() == [ship]
    end

    test "get_ship!/1 returns the ship with given id" do
      ship = ship_fixture()
      assert Connections.get_ship!(ship.id) == ship
    end

    test "create_ship/1 with valid data creates a ship" do
      assert {:ok, %Ship{} = ship} = Connections.create_ship(@valid_attrs)
      assert ship.latitude == 120.5
      assert ship.longitude == 120.5
      assert ship.shared_info == []
    end

    test "create_ship/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Connections.create_ship(@invalid_attrs)
    end

    test "update_ship/2 with valid data updates the ship" do
      ship = ship_fixture()
      assert {:ok, %Ship{} = ship} = Connections.update_ship(ship, @update_attrs)
      assert ship.latitude == 456.7
      assert ship.longitude == 456.7
      assert ship.shared_info == []
    end

    test "update_ship/2 with invalid data returns error changeset" do
      ship = ship_fixture()
      assert {:error, %Ecto.Changeset{}} = Connections.update_ship(ship, @invalid_attrs)
      assert ship == Connections.get_ship!(ship.id)
    end

    test "delete_ship/1 deletes the ship" do
      ship = ship_fixture()
      assert {:ok, %Ship{}} = Connections.delete_ship(ship)
      assert_raise Ecto.NoResultsError, fn -> Connections.get_ship!(ship.id) end
    end

    test "change_ship/1 returns a ship changeset" do
      ship = ship_fixture()
      assert %Ecto.Changeset{} = Connections.change_ship(ship)
    end
  end
end
