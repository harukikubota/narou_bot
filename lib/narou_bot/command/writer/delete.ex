defmodule NarouBot.Command.Writer.Delete do
  use NarouBot.Command
  alias NarouBot.Repo.{Writers, UsersCheckWriters}
  alias NarouBot.Command.Writer.Helper.UserCallableState

  def call(param) do
    user = Helper.current_user(param.user_id)
    writer = Writers.find(param.data.writer_id)

    type = case UserCallableState.judge(:delete, %{user_id: user.id, writer_id: writer.id}) do
      {:error} -> :error
      {:ok}    ->
        UsersCheckWriters.unlink_to(user.id, writer.id)

        export writer: writer
        :ok
    end

    render_with_send type
  end
end
