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
end
