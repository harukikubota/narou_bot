defmodule NarouBot.Command.Novel.ChangeToReadLater do
  use NarouBot.Command
  alias NarouBot.Repo.{Novels, UsersCheckNovels}
  alias NarouBot.Command.Novel.Helper.UserCallableState

  def call(param) do
    user = current_user(param)
    novel = Novels.find(param.data.novel_id)
    export novel: novel

    case UserCallableState.judge(:update_notify, :change_to_read_later, %{user_id: user.id, novel_id: novel.id}) do
      {:error} -> render_with_send :error
      {:ok}    ->
        n = Novels.find_by_ncode(novel.ncode)

        UsersCheckNovels.unlink_to(user.id, novel.id)
        UsersCheckNovels.link_to(user.id, novel.id, n.episode_id)

        render_with_send :ok
    end
  end
end
