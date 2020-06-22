defmodule NarouBot.Command.Novel.Show do
  use NarouBot.Command
  alias NarouBot.Repo.Novels

  def call(param) do
    user = Helper.current_user(param.user_id)
    novel = Novels.novel_detail(:one, user.id, param.data.novel_id)

    type = Map.get(novel.check_user, :type, "no_register")

    render_with_send(:ok, %{novel: novel, type: type}, param.key)
  end
end
