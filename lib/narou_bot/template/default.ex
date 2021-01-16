defmodule NarouBot.Template.Default do
  use NarouBot.Template

  def render(:unsupported, _),       do: %LineBot.Message.Text{text: "未対応です。"}
  def render(:notification_info, _), do: %LineBot.Message.Text{text: "ok"}
end
