defmodule NarouBot.Command.Utility.Separator do
  use NarouBot.Command

  def call(param), do: render_with_send(:ok, "-", param.key)
end
