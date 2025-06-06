defmodule NarouBot.Command.Novel.Add do
  use NarouBot.Command
  alias NarouBot.Repo.{
    UsersCheckNovels,
    Novels
  }
  alias NarouBot.Command.Novel.Helper.UserCallableState

  def call(param) do
    user = current_user(param)
    novel = Novels.find(param.data.novel_id)
    type = param.data.type

    export novel: novel, type: type

    case UserCallableState.judge(:read_later, :add, %{user_id: user.id, novel_id: novel.id}) do
      {:error} -> render_with_send :error
      {:ok}    ->
        if user.novel_register_max > UsersCheckNovels.user_register_count(type, user.id) do
          case type do
            "update_notify" -> UsersCheckNovels.link_to(user.id, novel.id)
            "read_later"    ->
              restart_episode_id = param.data.episode_id

              UsersCheckNovels.link_to(user.id, novel.id, restart_episode_id)
              export restart_episode_id: restart_episode_id
          end
          render_with_send :ok
        else
          render_with_send :registration_limit_over
        end
    end
  end
end
