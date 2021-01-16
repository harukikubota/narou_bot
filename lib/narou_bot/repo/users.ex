defmodule NarouBot.Repo.Users do
  use NarouBot.Repo

  alias NarouBot.Entity.User

  def find_or_create_by(line_id) do
    user = find_by_line_id(line_id)
    unless is_nil(user) do
      {:created, user}
    else
      {:ok, new_user(line_id)}
    end
  end

  def new_user(line_id), do: User.changeset(%User{}, %{line_id: line_id}) |> Repo.insert!
  def find_by_line_id(line_id), do: Repo.get_by(User, line_id: line_id)
  def enable_to(user),  do: User.changeset(user, %{enabled: true}) |> Repo.update!
  def disable_to(user), do: User.changeset(user, %{enabled: false}) |> Repo.update!

  def notification_target_users(notification_type, param) do
    _notification_target_users(notification_type, Map.new(param))
    |> select([user: u], u.id)
    |> distinct([user: u], u.id)
    |> Repo.all
  end

  defp _notification_target_users(:novel_new_episode, %{novel_id: novel_id}) do
    from u in User,
      as: :user,
      join: un in "users_check_novels", on: u.id == un.user_id,
      where: un.novel_id == ^novel_id and un.do_notify == true and un.type == "update_notify"
  end

  defp _notification_target_users(:new_post_novel, %{writer_id: writer_id}) do
    from u in User,
      as: :user,
      join: uw in "users_check_writers", on: u.id == uw.user_id,
      where: uw.writer_id == ^writer_id
  end

  defp _notification_target_users(:delete_writer, %{writer_id: writer_id}) do
    from u in User,
      as: :user,
      join: uw in "users_check_writers", on: u.id == uw.user_id,
      join: un in "users_check_novels",  on: u.id == un.user_id,
      join: n  in "novels",              on: n.id == un.novel_id,
      where: uw.writer_id == ^writer_id or n.writer_id == ^writer_id
  end

  defp _notification_target_users(:delete_novel, %{novel_id: novel_id}) do
    from u in User,
      as: :user,
      join: un in "users_check_novels", on: u.id == un.user_id,
      where: un.novel_id == ^novel_id
  end

  defp _notification_target_users(:delete_novel_episode, %{novel_id: novel_id, episode_id: episode_id}) do
    from u in User,
      as: :user,
      join: un in "users_check_novels", on: u.id == un.user_id,
      join: n  in "novels"            , on: n.id == ^novel_id,
      join: ne in "novel_episodes"    , on: n.id == ne.novel_id,
      join: ni in "notification_facts", on: u.id == ni.user_id,
      where: ni.status == 2 and ne.episode_id == ^episode_id
  end
end
