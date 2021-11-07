defmodule NarouBot.Command.Admin.RestStart do
  use NarouBot.Command
  import NarouBot.Command.Admin.Helper
  alias NarouBot.RestoreServer

  def setup(param) do
    %{is_admin: is_admin(param)}
  end

  def call(%{is_admin: true}) do
    RestoreServer.do_restore()

    Process.spawn(fn ->
      Process.sleep(20000)

      GenServer.stop(RestoreServer)
    end, [:monitor])

    render_with_send :ok
  end

  def call(%{is_admin: false}) do
    render_with_send :unsupported
  end
end
