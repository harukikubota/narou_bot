defmodule NarouBot.Template.Admin.RestStart do
  use NarouBot.Template

  def render(:ok, dao) do
    %LineBot.Message.Text{text: "リストアを開始しました。"}
  end

  def render(:unsupported, _) do
    NarouBot.Template.Default.render(:unsupported, nil)
  end
end
