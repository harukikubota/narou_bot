defmodule NarouBot.Command.Writer.List do
  use NarouBot.Command
  alias NarouBot.Repo.Writers

  def call(param) do
    user = Helper.current_user(param.user_id)
    writers = Writers.writer_detail(user.id)

    cond do
      length(writers) == 0 ->
        render_with_send(:no_registered, nil, param.key)
      length(writers) > 0 ->
        render_with_send(:ok, writers, param.key)
    end
  end
end
