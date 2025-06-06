defmodule NarouBot.Command.Novel.SwitchNotification do
  use NarouBot.Command
  alias NarouBot.Repo.{
    Novels,
    UsersCheckNovels,
    NotificationFacts
  }
  require Logger

  def call(param) do
    user_id = current_user(param).id
    novel = Novels.novel_detail(:one, user_id, param.data.novel_id)

    user_unread_count = NotificationFacts.user_unread_episode_count(user_id, novel.id)
    exec_delete_unread = !is_nil(Map.get(param.data, :do_delete))

    export novel: novel, unread_count: user_unread_count
    exec(user_id, novel, user_unread_count, exec_delete_unread)
    send_message()
  end

  def exec(user_id, novel, 0, _) do
    switch_notification(user_id, novel)
  end

  def exec(_, _, user_unread_count, false) when user_unread_count > 0 do
    render :confirm_delete_to_unread
  end

  def exec(user_id, novel, _, true) do
    unread_episodes = NotificationFacts.user_unread_episodes(user_id, novel.id)
    NotificationFacts.change_status_all(unread_episodes, "notificated")

    render :unread_episodes
    switch_notification(user_id, novel)
  end

  def switch_notification(user_id, novel) do
    case UsersCheckNovels.switch_notification(user_id, novel.id) do
      {:error} -> render :no_data
      {:ok}    ->
        export novel: Novels.novel_detail(:one, user_id, novel.id)
        render :ok
    end
  end
end
