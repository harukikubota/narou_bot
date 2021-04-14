defmodule NarouBot.Template.Admin.Info do
  use NarouBot.Template

  def render(:ok, dao) do
    text = [
      "【インフォメーション】",
      "レコード数：#{dao.count}"
    ] |> Enum.join("\n")

    %LineBot.Message.Text{text: text}
  end

  def render(:unsupported, _) do
    NarouBot.Template.Default.render(:unsupported, nil)
  end
end
