defmodule NarouBot.JobService.ApplyRemoteData do
  alias NarouBot.Repo
  alias Repo.{
    Novels,
    NovelEpisodes,
    Writers,
    Users,
    UsersCheckNovels,
    UsersCheckWriters,
    NotificationFacts
  }
  require Logger

  def start(arg) do
    case arg do
      {:novel_no_update, _}                   -> nil
      {type, %{local: local, remote: remote}} ->
        exec(type, local, remote)
        :ok
    end
  end

  def exec(type, local, remote) do
    logging(:start, type)
    data = setup(type, local, remote) |> logging_data()
    update_local_data(type, data)
    |> create_notification_data(type, data)
    logging(:end, type)
  end

  def logging(timing, type), do: Logger.info "#{timing} #{type}"

  def setup(:novel_new_episode, local, remote) do
    novel_id = local.id
    %{
      notification_target_user_ids: Users.notification_target_users(:novel_new_episode, novel_id: novel_id),
      novel_id:                     novel_id,
      episode_ids_to_create:        Range.new(local.last_episode.episode_id + 1, remote.episode_id),
      remote_created_at:            remote.remote_created_at,
    }
  end

  def setup(:new_post_novel, _, remote) do
    writer = Writers.find_by_remote_id(remote.writer_remote_id)
    %{
      notification_target_user_ids: Users.notification_target_users(:new_post_novel, writer_id: writer.id),
      novel_attr: %{
        ncode: remote.ncode,
        title: remote.title,
        writer_id: writer.id,
        remote_created_at: remote.remote_created_at,
        episode_id: 1
      }
    }
  end

  def setup(:delete_novel_episode, local, remote) do
    novel_id = local.id
    episode_ids_to_delete = Range.new(remote.episode_id + 1, local.last_episode.episode_id)
    notification_target_user_ids =
      Users.notification_target_users(:delete_novel_episode, novel_id: novel_id, episode_id: hd(Enum.to_list(episode_ids_to_delete)))

    %{
      notification_target_user_ids: notification_target_user_ids,
      episode_ids_to_delete: episode_ids_to_delete,
      novel_id: novel_id,
      remote_created_at: remote.remote_created_at
    }
  end

  def setup(:delete_novel, local, _) do
    novel_id = local.id
    %{
      notification_target_user_ids: Users.notification_target_users(:delete_novel, novel_id: novel_id),
      novel_id: novel_id
    }
  end

  def setup(:delete_writer, local, _) do
    writer_id = local.id
    %{
      notification_target_user_ids: Users.notification_target_users(:delete_writer, writer_id: writer_id),
      writer_id: writer_id
    }
  end

  def logging_data(data) do
    IO.inspect(data, label: "logging_data")
    data
  end


  def update_local_data(:novel_new_episode, data) do
    data.episode_ids_to_create
    |> Enum.map(&NovelEpisodes.create(%{novel_id: data.novel_id, episode_id: &1, remote_created_at: data.remote_created_at}))
  end

  def update_local_data(:new_post_novel, %{novel_attr: attr}), do: Novels.create_with_assoc_episode(attr)

  def update_local_data(:delete_novel_episode, data) do
    results =
      Enum.map(data.episode_ids_to_delete, &NovelEpisodes.delete_by_novel_param(data.novel_id, &1))
      |> Enum.reject(&is_nil/1)
      |> Enum.map(&elem(&1, 1))

    make_brank_record_if_local_episodes_not_exist(data)

    results
  end

  def update_local_data(:delete_novel, data) do
    Novels.delete(data.novel_id)
    UsersCheckNovels.unlink_all(data.novel_id)
  end

  def update_local_data(:delete_writer, data) do
    writer_id = data.writer_id
    Writers.delete(writer_id)
    UsersCheckWriters.unlink_all(writer_id)
    UsersCheckNovels.unlink_all_by_writer_id(writer_id)
  end


  def create_notification_data(created_novel_episodes, :novel_new_episode, data) do
    Enum.each(created_novel_episodes, fn %{id: novel_episode_id} ->
      data.notification_target_user_ids
      |> Enum.each(&NotificationFacts.create(%{type: :novel_new_episode, user_id: &1, novel_episode_id: novel_episode_id}))
    end)
  end

  def create_notification_data(%{id: novel_id}, :new_post_novel, data) do
    data.notification_target_user_ids
    |> Enum.each(&NotificationFacts.create(%{type: :new_post_novel, user_id: &1, novel_id: novel_id}))
  end

  def create_notification_data(deleted_novel_episodes, :delete_novel_episode, data) do
    Enum.each(deleted_novel_episodes, fn %{id: novel_episode_id} ->
      data.notification_target_user_ids
      |> Enum.each(&NotificationFacts.create(%{type: :delete_novel_episode, user_id: &1, novel_episode_id: novel_episode_id}))
    end)
  end

  def create_notification_data(_, :delete_novel, data) do
    data.notification_target_user_ids
    |> Enum.each(&NotificationFacts.create(%{type: :delete_novel, user_id: &1, novel_id: data.novel_id}))
  end

  def create_notification_data(_, :delete_writer, data) do
    data.notification_target_user_ids
    |> Enum.each(&NotificationFacts.create(%{type: :delete_writer, user_id: &1, writer_id: data.writer_id}))
  end

  defp make_brank_record_if_local_episodes_not_exist(data) do
    if Enum.empty?(NovelEpisodes.leatest_update_history(data.novel_id)) do
      %{
        novel_id: data.novel_id,
        episode_id: data.episode_ids_to_delete |> Enum.to_list |> hd |> Kernel.-(1),
        remote_created_at: data.remote_created_at
      }
      |> NovelEpisodes.create()
    end
  end
end
