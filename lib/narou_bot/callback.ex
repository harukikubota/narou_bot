defmodule NarouBot.Callback do
  use LineBot

  def handle_message(%{type: "text", text: message}, info) do
    reply = %LineBot.Message.Text{text: message}
    LineBot.send_reply(info.reply_token, reply)
  end
end
