defmodule NarouBot.Command.Utility.Menu do
  use NarouBot.Command

  def call(param) do
    IO.inspect param.name
  end
end
