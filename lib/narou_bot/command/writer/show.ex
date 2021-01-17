defmodule NarouBot.Command.Writer.Show do
  use NarouBot.Command
  alias NarouBot.Repo.Writers

  def call(param) do
    user = current_user(param)
    writer = Writers.writer_detail(user.id, param.data.writer_id)

    type = if writer do
      export writer: writer
      :ok
    else
      export writer: Writers.find(param.data.writer_id)
      :no_registered
    end

    render_with_send type
  end
end
