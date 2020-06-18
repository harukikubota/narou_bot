defmodule NarouBot.Router do
  use NarouBotWeb, :router
  forward "/bot", LineBot.Webhook, callback: NarouBot.Callback
end
