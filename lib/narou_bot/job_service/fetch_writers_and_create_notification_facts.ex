defmodule NarouBot.JobService.FetchWritersAndCreateNotificationFacts do
  alias NarouBot.Repo
  alias NarouBot.JobService.JobControlActivity
  alias NarouBot.Entity.Novel

  require Logger

  @child NarouBot.JobService.ApplyRemoteData
  @group_max_novel_cnt 2499

  def exec() do
    if JobControlActivity.job_activity? do
      Logger.info "start job FetchWritersAndCreateNotificationFacts"
      fetch_target_writers()
      |> grouping_writer_ids_to_fetch_data()
      |> Enum.each(&fetch_and_apply_remote_data/1)

      Logger.info "end job FetchWritersAndCreateNotificationFacts"
    else
      Logger.info "from FetchWritersAndCreateNotificationFacts: job stopped."
    end
  end

  defp fetch_target_writers(), do: Repo.Writers.records_to_fetch()

  defp grouping_writer_ids_to_fetch_data(writers) do
    writers
    |> add_index()
    |> Enum.group_by(&(elem(&1, 0)),&(elem(&1, 1)))
    |> Enum.map(fn {_,v} -> v end)
  end

  defp add_index(writers, group_id \\ 1, group_novel_cnt \\ 0)
  defp add_index([target|tail], group_id, group_novel_cnt) do
    current_count = target.novel_count + 1
    including_carry_over = current_count + group_novel_cnt

    {group_id, group_novel_cnt} =
      if including_carry_over <= @group_max_novel_cnt do
        {group_id, including_carry_over}
      else
        {group_id + 1, current_count}
      end

    [{group_id, target.remote_id}] ++ add_index(tail, group_id, group_novel_cnt)
  end
  defp add_index([], _, _), do: []

  defp fetch_and_apply_remote_data(writer_ids) do
    spawn(fn ->
      writer_ids
      |> Repo.Narou.find_by_userid([:n, :t, :ga, :gl, :u, :nt, :e])
      |> format!()
      |> grouping_writer()
      |> tagging_with(load_writers(writer_ids))
      |> Enum.each(&create_notification_facts/1)
    end)
  end

  defp grouping_writer(fetch_facts) do
    fetch_facts |> Enum.group_by(&(&1.writer_remote_id))
  end

  defp tagging_with(remote_writer_facts, local_writers) do
    get_remote_data = fn remote_id -> Map.get(remote_writer_facts, remote_id) end
    local_writers
    |> Enum.map(fn writer ->
      remote_data = get_remote_data.(writer.remote_id)

      cond do
        is_nil(remote_data) ->
          [tagged_fact(:delete_writer, writer, nil)]
        true ->
          (Enum.map(writer.novels, &(&1.ncode)) ++ Enum.map(remote_data, &(&1.ncode)))
          |> Enum.uniq
          |> Enum.map(fn ncode ->
            get_novel = fn enumerable -> Enum.find(enumerable, &(&1.ncode == ncode)) end

            tagging_novel(get_novel.(writer.novels), get_novel.(remote_data))
          end)
          |> Enum.flat_map(&(&1))
      end
    end)
    |> Enum.flat_map(&(&1))
  end

  defp tagging_novel(local, remote) do
    (cond do
      is_nil(remote) -> tagged_fact :delete_novel, local, nil
      is_nil(local)  -> tagged_fact :new_post_novel, nil, remote
      true           ->
        local_episode_id = local.last_episode.episode_id

        tag = cond do
          local_episode_id <  remote.episode_id -> :novel_new_episode
          local_episode_id >  remote.episode_id -> :delete_novel_episode
          local_episode_id == remote.episode_id -> :novel_no_update
        end

        if(remote.finished and !remote.is_short_story and !local.finished,
          do:   [tagged_fact(:novel_end, local, nil)],
          else: []
        )
        |> Kernel.++([tagged_fact(tag, local, remote)])
    end) |> List.wrap
  end

  defp tagged_fact(tag, local, remote), do: {tag, %{local: local, remote: remote}}

  defp load_writers(writer_ids), do: Repo.Writers.find_by_ids_with_novels(writer_ids)

  defp create_notification_facts(tagged_info), do: spawn(@child, :start, [tagged_info])

  defp format!({:ok, _, fetch_facts}) do
    Enum.map(fetch_facts, fn data ->
      %{
        episode_id:        data.general_all_no,
        remote_created_at: data.general_lastup,
        ncode:             data.ncode,
        title:             data.title,
        writer_remote_id:  data.userid,
        finished:          Novel.conv_finished(data.end),
        is_short_story:    Novel.conv_is_short_story(data.noveltype)
      }
    end)
  end
end
