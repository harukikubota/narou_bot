defmodule NarouBot.Template.Admin.Rest do
  use NarouBot.Template

  def render(:ok, dao) do
    %LineBot.Message.Text{text: dao.key}
  end

  def render(:unsupported, _) do
    NarouBot.Template.Default.render(:unsupported, nil)
  end
end
