defmodule NarouBot.Template.Novel.Add do
  use NarouBot.Template
  alias LineBot.Message, as: M
  alias NarouBot.Template.Common
  alias NarouBot.Template.Novel.Common, as: NCommon

  def render(:ok, dao), do: %M.Text{text: "「#{dao.novel.title}」を#{NCommon.to_jp(dao.type)}に追加しました。"}
  def render(:registration_limit_over, dao), do: %M.Text{text: "#{NCommon.to_jp(dao.type)}の登録上限に達しています。\n新しく登録するには削除してから登録してください。"}
  def render(:error, _), do: Common.render(:invalid_operation, nil)
end
