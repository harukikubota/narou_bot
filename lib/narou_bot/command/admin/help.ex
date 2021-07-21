defmodule NarouBot.Command.Admin.Help do
  use NarouBot.Command
  import NarouBot.Command.Admin.Helper

  def setup(param), do: %{is_admin: is_admin(param)}

  def call(%{is_admin: true}),  do: render_with_send :ok
  def call(%{is_admin: false}), do: render_with_send :unsupported
end
