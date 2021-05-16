defmodule NarouBot.Repo.Novels do
  use NarouBot.Repo

  alias Repo.{
    Util,
    NovelEpisodes,
    UsersCheckNovels,
    NotificationFacts
  }
  alias NarouBot.Entity.{
    Novel,
    Writer,
    UserCheckNovel
  }
  require Logger

  @spec all() :: list(map) | []
  def all() do
    Repo.all(Novel)
  end

  @spec find(integer) :: map | nil
  def find(id) do
    Repo.get(Novel, id)
  end

  def novel_detail(:all, type, user_id) do
    novel_detail_query(:registerd, user_id)
    |> where([user_check: u], u.type == ^type)
    |> Repo.all
    |> add_col_unread_count(:all, type)
  end

  def novel_detail(:one, user_id, novel_id) do
    record =
      (if UsersCheckNovels.registered?(user_id, novel_id) do
        novel_detail_query(:registerd, user_id)
      else
        novel_detail_query(:no_register)
      end)
      |> where([novels: n], n.id == ^novel_id)
      |> first()
      |> Repo.one

    add_col_unread_count(record, :one, Map.get(record.check_user, :type))
  end

  defp novel_detail_query(:registerd, user_id) do
    from(
      [n, w] in novel_detail_query(:no_register),
      join: ucn in UserCheckNovel,
        on: ucn.novel_id == n.id,
        as: :user_check,
      where: ucn.user_id == ^user_id,
      preload: [check_user: ucn]
    )
  end

  defp novel_detail_query(:no_register) do
    from(
      n in Novel,
        as: :novels,
      join: w in assoc(n, :writer),
        on: w.id == n.writer_id,
      preload: [
        writer: w,
        last_episode: ^NovelEpisodes.novel_last_episodes_query
      ]
    )
  end

  def add_col_unread_count(cols, :all, "update_notify") do
    Enum.map(cols, &add_col_unread_count(&1, :one, "update_notify"))
  end

  def add_col_unread_count(col, :one, "update_notify") do
    unless col.check_user.do_notify do
      Map.merge(col, %{unread_count: NotificationFacts.user_unread_episode_count(col.check_user.user_id, col.id)})
    else
      col
    end
  end

  def add_col_unread_count(col, _, _), do: col

  def find_by_ncode(ncode) do
    from(
      n in Novel,
      join: w  in Writer ,
        on: n.writer_id == w.id,
      join: ne in subquery(NovelEpisodes.novel_last_episodes_query),
        on: ne.novel_id == n.id,
      where: n.ncode == ^ncode
        and n.remote_deleted == false,
      select: %{
        id:                n.id,
        ncode:             n.ncode,
        title:             n.title,
        writer_name:       w.name,
        writer_id:         n.writer_id,
        finished:          n.finished,
        is_short_story:    n.is_short_story,
        episode_id:        ne.episode_id,
        remote_created_at: ne.remote_created_at,
      }
    )
    |> first()
    |> Repo.one
  end

  def find_or_create_by(ncode) do
    record = find_by_ncode(ncode)

    if is_nil(record) do
      case Repo.Narou.find_by_ncode(ncode, [:ga, :u, :t, :gl, :nt, :e]) do
        {:ok, %{
          general_all_no: episode_id,
          title:          title,
          userid:         remote_writer_id,
          general_lastup: general_lastup,
          noveltype:      novel_type,
          end:            finished
        }} ->
          {:ok, writer} = Repo.Writers.find_or_create_by(remote_writer_id)

          is_short_story = Novel.conv_is_short_story(novel_type)
          finished       = Novel.conv_finished(finished)

          novel =
            create_with_assoc_episode(
              %{
                ncode:             ncode,
                title:             title,
                writer_id:         writer.id,
                episode_id:        episode_id,
                remote_created_at: general_lastup,
                finished:          finished,
                is_short_story:    is_short_story
              }
            )

          {:ok, find_by_ncode(novel.ncode)}

        any -> any
      end
    else
      {:ok, record}
    end
  end

  def create(param) do
    Map.merge(%Novel{}, param) |> Repo.insert!
  end

  def create_with_assoc_episode(
    %{
      ncode:             ncode,
      title:             title,
      writer_id:         writer_id,
      episode_id:        episode_id,
      remote_created_at: remote_created_at,
      finished:          finished,
      is_short_story:    is_short_story
    }
  ) do
    try do
      novel = create(%{ncode: ncode, title: title, writer_id: writer_id, finished: finished, is_short_story: is_short_story})

      %{novel_id: novel.id, episode_id: episode_id, remote_created_at: remote_created_at}
      |> NovelEpisodes.create()

      novel
    rescue
      e in Ecto.ConstraintError ->
        Logger.warn("The novel revival process has begun.")
        Logger.warn("Ncode: #{ncode}")
        Logger.warn(inspect e)
        resurrection_novel(ncode)

        find_by_ncode(ncode)
    end
  end

  def delete(id) do
    find(id) |> Util.exec_delete()
  end

  def finish_episode(id) do
    from(
      Novel,
      where: [id: ^id],
      update: [
        set: [finished: true]
      ]
    )
    |> Repo.update_all([])
  end

  def resurrection_novel(ncode) do
    from(
      Novel,
      where: [ncode: ^ncode],
      update: [
        set: [remote_deleted: false]
      ]
    )
    |> Repo.update_all([])
  end
end
