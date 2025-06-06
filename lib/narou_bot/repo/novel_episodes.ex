defmodule NarouBot.Repo.NovelEpisodes do
  use NarouBot.Repo

  alias NarouBot.Entity.NovelEpisode

  def novel_last_episodes_query do
    from(
      ne in NovelEpisode,
      order_by: [desc: ne.episode_id],
      distinct: ne.novel_id,
      where: ne.remote_deleted == false
    )
  end

  def leatest_update_history(novel_id, limit \\ 10) do
    from(
      n in NovelEpisode,
      where: n.novel_id == ^novel_id
        and n.remote_deleted == false,
      order_by: [desc: n.episode_id],
      select: %{
        episode_id: n.episode_id,
        created_at: n.remote_created_at
      },
      limit: ^limit
    )
    |> Repo.all
  end

  # FIXME UTCタイム受け取るように修正したい
  def create(%{novel_id: novel_id, episode_id: episode_id, remote_created_at: created}) do
    %NovelEpisode{}
    |> Map.merge(%{novel_id: novel_id, episode_id: episode_id, remote_created_at: created})
    |> format_jpdate_to_utc(:remote_created_at)
    |> Repo.insert!
  end

  def delete(id) do
    Repo.get(NovelEpisode, id)
    |> exec_delete()
  end

  def delete_by_novel_param(novel_id, episode_id) do
    from(
      ne in NovelEpisode,
      where: ne.novel_id == ^novel_id
        and ne.episode_id == ^episode_id
        and ne.remote_deleted == false
    )
    |> first()
    |> Repo.one()
    |> then(fn rec -> if(rec, do: exec_delete(rec)) end)
  end
end
