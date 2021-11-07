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

  scope "/bot" do
    forward "/", LineBot.Webhook, callback: NarouBot.Callback
  end

  scope "/api", NarouBotWeb do
    pipe_through :api
    post "/dump", ApiController, :dump
    post "/rest", ApiController, :rest
  end
end
