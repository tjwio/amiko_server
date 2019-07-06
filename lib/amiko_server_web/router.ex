defmodule AmikoServerWeb.Router do
  use AmikoServerWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :authenticated do
    plug AmikoServerWeb.Pipelines.Auth
  end

  scope "/api/v1", AmikoServerWeb do
    pipe_through :api # Use the default browser stack

    post "/signup", UserController, :signup
    post "/login", UserController, :login

    pipe_through :authenticated
    get "/users/me", UserController, :show
    get "/users/profile/:id", UserController, :show_specific
    put "/users/me", UserController, :update_user

    get "/users/connections", UserController, :get_connections
    post "/users/connections", UserController, :add_connection
    delete "/users/connections/:id", UserController, :delete_connection

    get "/ships", ShipController, :get_ships
    post "/ships", ShipController, :add_ship

    get "/cards", CardController, :get_cards
    get "/cards/public/:id", CardController, :get_public_card
    post "/cards", CardController, :add_card

    post "/upload/image", UploadController, :upload
  end
end
