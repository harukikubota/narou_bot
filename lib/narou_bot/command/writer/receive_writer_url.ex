defmodule NarouBot.Command.Writer.ReceiveWriterUrl do
  use NarouBot.Command
  alias NarouBot.Repo.{Writers, Users, UsersCheckWriters}

  def call(param) do
    type = case Writers.find_or_create_by(param.writer_id) do
      {:no_data}    -> :no_data
      {:ok, writer} ->
        user = Users.find_by_line_id(param.user_id)
        export writer: writer

        if UsersCheckWriters.registered?(user.id, writer.id), do: :registered, else: :no_register
    end

    render_with_send type
  end
end
