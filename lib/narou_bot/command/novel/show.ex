defmodule NarouBot.Command.Novel.Show do
  use NarouBot.Command
  alias NarouBot.Repo.Novels

  def call(param) do
    user = current_user(param)
    novel = Novels.novel_detail(:one, user.id, param.data.novel_id)

    export novel: novel, user: user, type: Map.get(novel.check_user, :type, "no_register")
    render_with_send :ok
  end
end
