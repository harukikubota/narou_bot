defmodule NarouBot.Command.Novel.Update do
  use NarouBot.Command
  alias NarouBot.Repo.{
    UsersCheckNovels,
    Novels
  }
  alias NarouBot.Command.Novel.Helper.UserCallableState

  def call(param) do
    user = current_user(param)
    novel = Novels.find(param.data.novel_id)
    restart_episode_id = param.data.episode_id

    export novel: novel, restart_episode_id: restart_episode_id

    type = case UserCallableState.judge(:read_later, :update, %{user_id: user.id, novel_id: novel.id}) do
      {:error} -> :error
      {:ok}    ->
        UsersCheckNovels.update_episode_id(user.id, novel.id, restart_episode_id)
        :ok
    end

    render_with_send type
  end
end
