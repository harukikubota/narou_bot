defmodule NarouBot.Template.Novel.ChangeToUpdateNotify do
  use NarouBot.Template
  alias LineBot.Message, as: M
  alias NarouBot.Template.Common

  def render(:ok, dao),  do: %M.Text{text: "「#{dao.novel.title}」を後で読むから更新通知に変更しました。"}
  def render(:error, _), do: Common.render(:invalid_operation, nil)
end
