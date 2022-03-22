defmodule NarouBot.Template.Novel.ChangeToReadLater do
  use NarouBot.Template
  alias LineBot.Message, as: M
  alias NarouBot.Template.Common

  def render(:ok, dao),  do: %M.Text{text: "「#{dao.novel.title}」を更新通知から後で読むに変更しました。"}
  def render(:error, _), do: Common.render(:invalid_operation, nil)
end
