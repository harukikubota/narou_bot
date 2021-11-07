defmodule NarouBot.Command.Admin.Rest do
  use NarouBot.Command
  import NarouBot.Command.Admin.Helper
  alias NarouBot.RestoreServer

  def setup(param) do
    %{is_admin: is_admin(param)}
  end

  def call(%{is_admin: true}) do
    {:ok, _} = RestoreServer.start_link(:restore)

    export key: RestoreServer.get_key(:restore)
    render_with_send :ok
  end

  def call(%{is_admin: false}) do
    render_with_send :unsupported
  end
end
