defmodule AmikoServer.AccountsTest do
  use AmikoServer.DataCase

  alias AmikoServer.Accounts

  describe "users" do
    alias AmikoServer.Accounts.User

    @valid_attrs %{company: "some company", email: "some email", facebook: "some facebook", first_name: "some first_name", image_url: "some image_url", instagram: "some instagram", last_name: "some last_name", linkedin: "some linkedin", password_hash: "some password_hash", phone: "some phone", profession: "some profession", twitter: "some twitter", website: "some website"}
    @update_attrs %{company: "some updated company", email: "some updated email", facebook: "some updated facebook", first_name: "some updated first_name", image_url: "some updated image_url", instagram: "some updated instagram", last_name: "some updated last_name", linkedin: "some updated linkedin", password_hash: "some updated password_hash", phone: "some updated phone", profession: "some updated profession", twitter: "some updated twitter", website: "some updated website"}
    @invalid_attrs %{company: nil, email: nil, facebook: nil, first_name: nil, image_url: nil, instagram: nil, last_name: nil, linkedin: nil, password_hash: nil, phone: nil, profession: nil, twitter: nil, website: nil}

    def user_fixture(attrs \\ %{}) do
      {:ok, user} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_user()

      user
    end

    test "list_users/0 returns all users" do
      user = user_fixture()
      assert Accounts.list_users() == [user]
    end

    test "get_user!/1 returns the user with given id" do
      user = user_fixture()
      assert Accounts.get_user!(user.id) == user
    end

    test "create_user/1 with valid data creates a user" do
      assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
      assert user.company == "some company"
      assert user.email == "some email"
      assert user.facebook == "some facebook"
      assert user.first_name == "some first_name"
      assert user.image_url == "some image_url"
      assert user.instagram == "some instagram"
      assert user.last_name == "some last_name"
      assert user.linkedin == "some linkedin"
      assert user.password_hash == "some password_hash"
      assert user.phone == "some phone"
      assert user.profession == "some profession"
      assert user.twitter == "some twitter"
      assert user.website == "some website"
    end

    test "create_user/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
    end

    test "update_user/2 with valid data updates the user" do
      user = user_fixture()
      assert {:ok, %User{} = user} = Accounts.update_user(user, @update_attrs)
      assert user.company == "some updated company"
      assert user.email == "some updated email"
      assert user.facebook == "some updated facebook"
      assert user.first_name == "some updated first_name"
      assert user.image_url == "some updated image_url"
      assert user.instagram == "some updated instagram"
      assert user.last_name == "some updated last_name"
      assert user.linkedin == "some updated linkedin"
      assert user.password_hash == "some updated password_hash"
      assert user.phone == "some updated phone"
      assert user.profession == "some updated profession"
      assert user.twitter == "some updated twitter"
      assert user.website == "some updated website"
    end

    test "update_user/2 with invalid data returns error changeset" do
      user = user_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
      assert user == Accounts.get_user!(user.id)
    end

    test "delete_user/1 deletes the user" do
      user = user_fixture()
      assert {:ok, %User{}} = Accounts.delete_user(user)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
    end

    test "change_user/1 returns a user changeset" do
      user = user_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user(user)
    end
  end

  describe "cards" do
    alias AmikoServer.Accounts.Card

    @valid_attrs %{}
    @update_attrs %{}
    @invalid_attrs %{}

    def card_fixture(attrs \\ %{}) do
      {:ok, card} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Accounts.create_card()

      card
    end

    test "list_cards/0 returns all cards" do
      card = card_fixture()
      assert Accounts.list_cards() == [card]
    end

    test "get_card!/1 returns the card with given id" do
      card = card_fixture()
      assert Accounts.get_card!(card.id) == card
    end

    test "create_card/1 with valid data creates a card" do
      assert {:ok, %Card{} = card} = Accounts.create_card(@valid_attrs)
    end

    test "create_card/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_card(@invalid_attrs)
    end

    test "update_card/2 with valid data updates the card" do
      card = card_fixture()
      assert {:ok, %Card{} = card} = Accounts.update_card(card, @update_attrs)
    end

    test "update_card/2 with invalid data returns error changeset" do
      card = card_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_card(card, @invalid_attrs)
      assert card == Accounts.get_card!(card.id)
    end

    test "delete_card/1 deletes the card" do
      card = card_fixture()
      assert {:ok, %Card{}} = Accounts.delete_card(card)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_card!(card.id) end
    end

    test "change_card/1 returns a card changeset" do
      card = card_fixture()
      assert %Ecto.Changeset{} = Accounts.change_card(card)
    end
  end
end
