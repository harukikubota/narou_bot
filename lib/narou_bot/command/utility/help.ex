defmodule NarouBot.Command.Utility.Help do
  use NarouBot.Command

  def call(_param) do
    render_with_send :ok
  end
end
