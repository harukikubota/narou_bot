defmodule NarouBot.Command.Utility.Help do
  use NarouBot.Command

  def call(param) do
    render_with_send(:ok, nil, param.key)
  end
end
