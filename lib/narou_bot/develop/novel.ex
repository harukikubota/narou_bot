defmodule NarouBot.Develop.Novel do
  import Ecto.Query
  alias NarouBot.Repo
  alias NarouBot.Repo.{
    Novels,
    NovelEpisodes,
  }
  alias NarouBot.Entity.Novel

  @doc """
  指定した小説のダミーエピソードをN件作成する。

  iex> create_dummy_episodes("n2267be", 3)
  正規最新話: 490話
  ダミー   : 493話
  :ok
  """
  @spec create_dummy_episodes(binary(), pos_integer()) :: :ok
  def create_dummy_episodes(ncode, num_to_create, dummy_date \\ "2021-01-01 00:00:00") do
    target =
      from(n in Novel,
           where: n.ncode == ^ncode,
           limit: 1,
           preload: [last_episode: ^NovelEpisodes.novel_last_episodes_query]
      )
    |> Repo.one

    l_id = target.last_episode.episode_id
    dummy_l_id = l_id + num_to_create

    Enum.each(
      (l_id + 1)..dummy_l_id,
      &NovelEpisodes.create(%{novel_id: target.id, episode_id: &1, remote_created_at: dummy_date})
    )
    IO.puts """
    正規最新話: #{l_id}話
    ダミー   : #{dummy_l_id}話
    """
  end
end
