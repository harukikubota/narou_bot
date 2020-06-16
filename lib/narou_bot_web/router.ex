defmodule NarouBotWeb.Router do
  use NarouBotWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  pipeline :linebot do
    plug NarouBot.Router
  end

  scope "/", NarouBotWeb do
    pipe_through :browser # Use the default browser stack

    post "/callback", LineBotController, :callback
  end

  # Other scopes may use custom stacks.
  # scope "/api", NarouBotWeb do
  #   pipe_through :api
  # end
end
