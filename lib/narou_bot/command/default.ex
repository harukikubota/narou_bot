defmodule NarouBot.Command.Default do
  use NarouBot.Command

  def call(param) do
    render_with_send(:unsupported, nil, param.key)
  end
end
