defmodule NarouBot.Command.Novel.ShowUserUnreadEpisode do
  use NarouBot.Command
  alias NarouBot.Repo.{
    Novels,
    NotificationFacts
  }

  def setup(param) do
    user = Helper.current_user(param.user_id)
    novel = Novels.novel_detail(:one, user.id, param.data.novel_id)
    %{
      user: user,
      novel: novel,
      on_confirm: String.to_atom(param.data.confirm),
      on_notify: Map.get(novel.check_user, :do_notify)
    }
  end

  def call(param) do
    %{user: %{id: user_id}, novel: novel, on_confirm: on_confirm, on_notify: on_notify} = setup(param)

    export novel: novel

    type = cond do
      on_notify != false      -> :error
      novel.unread_count == 0 -> :no_unread
      on_confirm              -> :confirm
      true ->
        unread_episodes = NotificationFacts.user_unread_episodes(user_id, novel.id)
        NotificationFacts.change_status_all(unread_episodes, "notificated")

        export unread_episodes: unread_episodes
        :unread_episodes
    end

    render_with_send type
  end
end
