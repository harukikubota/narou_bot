defmodule NarouBot.Router do
  use Plug.Router
  plug :match
  plug :dispatch
  forward "/bot", to: LineBot.Webhook, callback: NarouBot.Callback
end
