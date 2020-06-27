defmodule NarouBot.Command.Writer.Add do
  use NarouBot.Command
  alias NarouBot.Repo.{
    UsersCheckWriters,
    Writers
  }
  alias NarouBot.Command.Writer.Helper.UserCallableState

  def call(param) do
    user = Helper.current_user(param.user_id)
    writer = Writers.find(param.data.writer_id)

    type = case UserCallableState.judge(:add, %{user_id: user.id, writer_id: writer.id}) do
      {:error} -> :error
      {:ok}    ->
        if user.writer_register_max > UsersCheckWriters.user_register_count(user.id) do
          UsersCheckWriters.link_to(user.id, writer.id)

          export writer: writer
          :ok
        else
          :registration_limit_over
        end
    end

    render_with_send type
  end
end
