defmodule NarouBot.Command.Admin.Info do
  use NarouBot.Command
  alias NarouBot.Repo

  def setup(param) do
    left = NarouBot.Util.Secure.admin_id_to_hash(param.user_id)
    right = System.get_env("ADMIN_USER_ID") |> String.to_integer()

    %{is_admin: left == right}
  end

  def call(%{is_admin: true}) do
    export count: Repo.AdminInfo.record_counts()
    render_with_send :ok
  end

  def call(%{is_admin: false}) do
    render_with_send :unsupported
  end
end
