defmodule NarouBot.Command.Default do
  use NarouBot.Command

  def call(_param), do: render_with_send :unsupported
end
