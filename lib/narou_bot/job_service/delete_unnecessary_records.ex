defmodule NarouBot.JobService.DeleteUnnecessaryRecords do
  @moduledoc """
      不要なレコードを削除する
  """

  # TODO レコード定義修正、本番をダンプ→ローカルへエクスポート、バッチ動かしてみる

  alias NarouBot.JobService.JobControlActivity
  alias NarouBot.Repo
  alias NarouBot.Entity.{
    Novel,
    NotificationInfo,
    NovelEpisode
  }
  alias NarouBot.Entity.NotificationInfo.NotificationStatus, as: Status

  import Ecto.Query

  require Logger

  def exec do
    if JobControlActivity.job_activity? do
      Logger.info "start job DeleteUnnecessaryRecords"

      do_delete()

      Logger.info "end   job DeleteUnnecessaryRecords"
    else
      Logger.info "from DeleteUnnecessaryRecords: job stopped."
    end
  end

  def do_delete do
    [
      :notification_facts,
      :novel_episodes
    ]
    |> Enum.each(fn sym ->
      {count, _ } = query(sym) |> Repo.delete_all

      if count > 0 do
        Logger.info("from DeleteUnnecessaryRecords: type: #{sym}, count: #{count}")
      end
    end)
  end

  # 一週間以前で通知済みレコード
  def query(:notification_facts) do
    record_status = Status.__enum_map__()[:notificated]
    target_date_time =
      Timex.today
      |> Timex.shift(days: -7)
      |> Timex.to_naive_datetime

    from(
      n in NotificationInfo,
      where: n.status == ^record_status
        and n.inserted_at < ^target_date_time
    )
  end

  def query(:novel_episodes) do
    record_limit = 12

    from(
      n in Novel,
      join: ne in NovelEpisode,
        on: n.id == ne.novel_id,
      order_by: [ne.episode_id],
      preload: [episodes: ne]
    )
    |> Repo.all
    |> Enum.filter(&(length(&1.episodes) > record_limit))
    |> Enum.map(&(&1.episodes))
    |> Enum.map(
      fn episodes ->
        Enum.slice(episodes, 0..-(record_limit + 1))
        |> Enum.map(&(&1.id))
      end
    )
    |> Enum.flat_map(&(&1))
    |> then(fn ids -> from(n in NovelEpisode, where: n.id in ^ids) end)
  end
end
