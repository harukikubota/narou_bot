defmodule NarouBot.Repo.UsersCheckNovels do
  use NarouBot.Repo

  alias NarouBot.Repo.Users
  alias NarouBot.Entity.{UserCheckNovel, Novel}

  def registered?(user_id, novel_id) do
    from(
      UserCheckNovel,
      where: [
        user_id: ^user_id,
        novel_id: ^novel_id
      ]
    )
    |> Repo.exists?
  end

  def registered?(user_id, novel_id, type) do
    type = to_string(type)

    from(
      UserCheckNovel,
      where: [
        user_id: ^user_id,
        novel_id: ^novel_id,
        type: ^type]
    )
    |> Repo.exists?
  end

  def user_register_count(type, user_id) do
    from(
      uc in UserCheckNovel,
      where: uc.user_id == ^user_id
        and uc.type == ^type,
      select: count()
    )
    |> Repo.one()
  end

  def link_to(user_id, novel_id) do
    UserCheckNovel.ch_update_notify(%UserCheckNovel{}, %{user_id: user_id, novel_id: novel_id})
    |> Repo.insert!
  end

  def link_to(user_id, novel_id, restart_episode_id) do
    UserCheckNovel.ch_read_later(%UserCheckNovel{}, %{user_id: user_id, novel_id: novel_id, restart_episode_id: restart_episode_id})
    |> Repo.insert!
  end

  def unlink_to(user_id, novel_id) do
    from(
      UserCheckNovel,
      where: [
        user_id: ^user_id,
        novel_id: ^novel_id]
    )
    |> Repo.delete_all
  end

  def unlink_all(novel_id) do
    user_ids = Users.notification_target_users(:delete_novel, novel_id: novel_id)

    from(
      uc in UserCheckNovel,
      where: uc.user_id in ^user_ids
        and uc.novel_id == ^novel_id
    )
    |> Repo.delete_all
  end

  def unlink_all_by_writer_id(writer_id) do
    from(
      uc in UserCheckNovel,
      where: uc.novel_id in subquery(
        from(
          uc in UserCheckNovel,
          join: n in Novel,
            on: n.id == uc.novel_id,
          where: n.writer_id == ^writer_id,
          select: [:novel_id]
        )
      )
    )
    |> Repo.delete_all
  end

  def find(user_id, novel_id, type) do
    type = to_string(type)

    from(
      UserCheckNovel,
      where: [
        user_id: ^user_id,
        novel_id: ^novel_id,
        type: ^type]
    )
    |> first()
    |> Repo.one()
  end

  def update_episode_id(user_id, novel_id, restart_episode_id) do
    from(
      UserCheckNovel,
      where: [
        user_id: ^user_id,
        novel_id: ^novel_id,
        type: "read_later"
      ],
      update: [
        set: [restart_episode_id: ^restart_episode_id]
      ]
    )
    |> Repo.update_all([])
  end

  def switch_notification(user_id, novel_id, turned_at \\ 0) do
    target = find(user_id, novel_id, :update_notify)

    if target do
      turned_at = if turned_at > 0, do: turned_at, else: DateTime.utc_now
      set = [do_notify: !target.do_notify, turn_off_notification_at: turned_at]

      from(
        n in UserCheckNovel,
        where: n.user_id == ^user_id
          and n.novel_id == ^novel_id
      )
      |> Repo.update_all(set: set)

      {:ok}
    else
      {:error}
    end
  end
end
