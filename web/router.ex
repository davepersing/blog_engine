defmodule BlogEngine.Router do
  use BlogEngine.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
    plug BlogEngine.CurrentUserPlug
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BlogEngine do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController do
      resources "/posts", PostController
    end

    resources "/posts", PostController, only: [:index]
    resources "/sessions", SessionController, only: [:new, :create, :delete]
    resources "/posts", PostController, only: [] do
        resources "/comments", CommentController, only: [:create, :delete, :update]
      end
  end

  # Other scopes may use custom stacks.
  # scope "/api", BlogEngine do
  #   pipe_through :api
  # end
end
