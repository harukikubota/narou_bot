defmodule NarouBot.Template.Common do
  use NarouBot.Template

  def render(:invalid_operation, _), do: %LineBot.Message.Text{text: "無効な操作です。"}
end
