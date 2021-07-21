defmodule NarouBot.Command.Admin.Info do
  use NarouBot.Command
  alias NarouBot.Repo
  import NarouBot.Command.Admin.Helper

  def setup(param) do
    %{is_admin: is_admin(param)}
  end

  def call(%{is_admin: true}) do
    export count: Repo.AdminInfo.record_counts()
    render_with_send :ok
  end

  def call(%{is_admin: false}) do
    render_with_send :unsupported
  end
end
