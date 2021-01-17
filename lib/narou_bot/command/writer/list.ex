defmodule NarouBot.Command.Writer.List do
  use NarouBot.Command
  alias NarouBot.Repo.Writers

  def call(param) do
    user = current_user(param)
    writers = Writers.writer_detail(user.id)

    export writers: writers
    render_with_send(unless length(writers) == 0, do: :ok, else: :no_registered)
  end
end
