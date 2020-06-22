defmodule NarouBot.Template.Writer.Delete do
  use NarouBot.Template
  alias LineBot.Message, as: M
  alias NarouBot.Template.Common

  def render(:ok, dao), do: %M.Text{text: "#{dao.writer.name}を更新通知から削除しました"}
  def render(:error, _), do: Common.render(:invalid_operation, nil)
end
