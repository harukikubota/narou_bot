defmodule NarouBot.Template.Utility.Separator do
  use NarouBot.Template
  alias LineBot.Message, as: M

  def render(:ok, delimita), do: %M.Text{ text: String.duplicate(delimita, 10)}
end
