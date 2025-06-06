defmodule NarouBot.Command.Novel.ChangeToUpdateNotify do
  use NarouBot.Command
  alias NarouBot.Repo.{Novels, UsersCheckNovels}
  alias NarouBot.Command.Novel.Helper.UserCallableState

  def call(param) do
    user = current_user(param)
    novel = Novels.find(param.data.novel_id)
    export novel: novel

    case UserCallableState.judge(:read_later, :change_to_update_notify, %{user_id: user.id, novel_id: novel.id}) do
      {:error} -> render_with_send :error
      {:ok}    ->
        UsersCheckNovels.unlink_to(user.id, novel.id)
        UsersCheckNovels.link_to(user.id, novel.id)

        render_with_send :ok
    end
  end
end
