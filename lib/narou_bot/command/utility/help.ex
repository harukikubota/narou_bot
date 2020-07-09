defmodule NarouBot.Command.Utility.Help do
  use NarouBot.Command

  def setup(param) do
    if Map.has_key?(param, :show_type), do: %{}, else: %{show_type: "list"}
  end

  def call(%{show_type: type}) do
    render_with_send type
  end
end
