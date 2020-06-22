defmodule NarouBot.Template.Default do
  use NarouBot.Template
  alias NarouBot.Template.JobService.Notificate_data, as: T

  def render(:unsupported, _), do: %LineBot.Message.Text{text: "未対応です。"}

  def render(:notification_info, _) do
    %LineBot.Message.Text{text: "ok"}
  end
end
