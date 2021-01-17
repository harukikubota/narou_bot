defmodule NarouBot.Command.Novel.List do
  use NarouBot.Command
  alias NarouBot.Repo.Novels

  def call(param) do
    user = current_user(param)
    type = param.data.type
    novels = Novels.novel_detail(:all, type, user.id)

    export type: type, novels: novels
    render_with_send(unless length(novels) == 0, do: :ok, else: :no_registered)
  end
end
