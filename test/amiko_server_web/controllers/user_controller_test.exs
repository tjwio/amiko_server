defmodule AmikoServerWeb.UserControllerTest do
  use AmikoServerWeb.ConnCase

  alias AmikoServer.Accounts
  alias AmikoServer.Accounts.User

  @create_attrs %{
    company: "some company",
    email: "some email",
    facebook: "some facebook",
    first_name: "some first_name",
    image_url: "some image_url",
    instagram: "some instagram",
    last_name: "some last_name",
    linkedin: "some linkedin",
    password_hash: "some password_hash",
    phone: "some phone",
    profession: "some profession",
    twitter: "some twitter",
    website: "some website"
  }
  @update_attrs %{
    company: "some updated company",
    email: "some updated email",
    facebook: "some updated facebook",
    first_name: "some updated first_name",
    image_url: "some updated image_url",
    instagram: "some updated instagram",
    last_name: "some updated last_name",
    linkedin: "some updated linkedin",
    password_hash: "some updated password_hash",
    phone: "some updated phone",
    profession: "some updated profession",
    twitter: "some updated twitter",
    website: "some updated website"
  }
  @invalid_attrs %{company: nil, email: nil, facebook: nil, first_name: nil, image_url: nil, instagram: nil, last_name: nil, linkedin: nil, password_hash: nil, phone: nil, profession: nil, twitter: nil, website: nil}

  def fixture(:user) do
    {:ok, user} = Accounts.create_user(@create_attrs)
    user
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all users", %{conn: conn} do
      conn = get(conn, Routes.user_path(conn, :index))
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create user" do
    test "renders user when data is valid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @create_attrs)
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "company" => "some company",
               "email" => "some email",
               "facebook" => "some facebook",
               "first_name" => "some first_name",
               "image_url" => "some image_url",
               "instagram" => "some instagram",
               "last_name" => "some last_name",
               "linkedin" => "some linkedin",
               "password_hash" => "some password_hash",
               "phone" => "some phone",
               "profession" => "some profession",
               "twitter" => "some twitter",
               "website" => "some website"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.user_path(conn, :create), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update user" do
    setup [:create_user]

    test "renders user when data is valid", %{conn: conn, user: %User{id: id} = user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @update_attrs)
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get(conn, Routes.user_path(conn, :show, id))

      assert %{
               "id" => id,
               "company" => "some updated company",
               "email" => "some updated email",
               "facebook" => "some updated facebook",
               "first_name" => "some updated first_name",
               "image_url" => "some updated image_url",
               "instagram" => "some updated instagram",
               "last_name" => "some updated last_name",
               "linkedin" => "some updated linkedin",
               "password_hash" => "some updated password_hash",
               "phone" => "some updated phone",
               "profession" => "some updated profession",
               "twitter" => "some updated twitter",
               "website" => "some updated website"
             } = json_response(conn, 200)["data"]
    end

    test "renders errors when data is invalid", %{conn: conn, user: user} do
      conn = put(conn, Routes.user_path(conn, :update, user), user: @invalid_attrs)
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete user" do
    setup [:create_user]

    test "deletes chosen user", %{conn: conn, user: user} do
      conn = delete(conn, Routes.user_path(conn, :delete, user))
      assert response(conn, 204)

      assert_error_sent 404, fn ->
        get(conn, Routes.user_path(conn, :show, user))
      end
    end
  end

  defp create_user(_) do
    user = fixture(:user)
    {:ok, user: user}
  end
end
