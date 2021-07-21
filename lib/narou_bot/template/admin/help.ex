defmodule NarouBot.Template.Admin.Help do
  use NarouBot.Template

  def render(:ok, _dao) do
    text = [
      h: "ヘルプの表示",
      i: "インフォメーション"
    ]
    |> Enum.map(fn {k, v} -> "#{k}: #{v}" end)
    |> Enum.join("\n")

    %LineBot.Message.Text{text: text}
  end

  def render(:unsupported, _) do
    NarouBot.Template.Default.render(:unsupported, nil)
  end
end
