defmodule NarouBot.Template.Utility.Help do
  use NarouBot.Template
  alias LineBot.Message, as: M

  def render(:ok, _) do
    %M.Text{text: "ヘルプは未実装です。しばしお待ちを。。。"}
  end
end
