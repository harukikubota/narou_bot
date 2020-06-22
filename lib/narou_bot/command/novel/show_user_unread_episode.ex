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

    dao = %{novel: novel}

    cond do
      on_notify != false      -> render_with_send(:error, nil, param.key)
      novel.unread_count == 0 -> render_with_send(:no_unread, dao, param.key)
      on_confirm              -> render_with_send(:confirm, dao, param.key)
      true ->
        unread_episodes = NotificationFacts.user_unread_episodes(user_id, novel.id)
        NotificationFacts.change_status_all(unread_episodes, "notificated")

        dao = Map.merge(dao, %{unread_episodes: unread_episodes})

        render_with_send(:unread_episodes, dao, param.key)
    end
  end
end
