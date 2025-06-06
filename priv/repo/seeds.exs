#mix ecto.drop && mix ecto.create && mix ecto.migrate && mix run priv/repo/seed.exs
defmodule NarouBot.Seed do
  import Ecto.Query
  alias NarouBot.Repo
  alias Repo.{
    Users,
    Novels,
    Writers,
    UsersCheckNovels,
    UsersCheckWriters,
    NovelEpisodes,
    NotificationFacts
  }
  alias NarouBot.Entity.{
    Novel,
    NovelEpisode
  }

  def main do
    setup()
    create_sfo_histries_date(1)
    create_dummy_writer_and_link()
    create_dummy_new_episode("n2267be")
    create_dummy_new_episode("n2267be")
    create_befor_the_latest_episode()
    delete_novel_leatest_episode()
    create_dummy_and_link(1)
    delete_for_new_post_novel(2)
    rec = [NarouBot.Repo.NotificationFacts.create(%{type: :novel_new_episode, user_id: 1, novel_episode_id: 26})]
    NarouBot.Repo.NotificationFacts.change_status_all(rec, "notificated")
  end

  def create_many_writers do
    remote_ids =
      [
        161807,
        235132,
        311735,
        430311,
        474038,
        552120,
        491287,
        288399,
        151239,
        631969,
        960535,
        224211,
        168215,
        313910,
        242986,
        509642
      ]

    remote_ids |> Enum.each(&Writers.find_or_create_by/1)
  end

  def create_dummy_new_episode(ncode) do
    target = from(
      n in Novel,
      where: n.ncode == ^ncode,
      limit: 1,
      preload: [last_episode: ^NovelEpisodes.novel_last_episodes_query])
    |> Repo.one

    NovelEpisodes.create(
      %{
        novel_id: target.id,
        episode_id: target.last_episode.episode_id + 1,
        remote_created_at: "2020-06-05 01:00:00"}
    )
  end

  def create_dummy_writer_and_link() do
    writer = Writers.create(%{remote_id: 9999999, name: "だみ太郎"})
    novel = Novels.create_with_assoc_episode(
      %{ncode: "n9999aab", title: "だみ太郎の冒険", writer_id: writer.id, remote_created_at: "2020-05-13 02:01:00", episode_id: 1}
    )

    UsersCheckWriters.link_to(1, writer.id)
    #UsersCheckNovels.link_to(2, novel.id)
  end

  def setup do
    user = Users.new_user "Uc043bb4602f875df9d19e266c67d0f57"
    #tuser = Users.new_user "hogehoge"

    {:ok, sfo} = Novels.find_or_create_by("n6169dz")
    {:ok, rzr} = Novels.find_or_create_by("n2267be")
    {:ok, tsr} = Novels.find_or_create_by("n6316bn")
    {:ok, mks} = Novels.find_or_create_by("n6715cb")
    {:ok, ubr} = Novels.find_or_create_by("n9016cm")
    {:ok, nmn} = Novels.find_or_create_by("n9078bd")

    UsersCheckNovels.link_to(user.id, sfo.id)
    UsersCheckNovels.link_to(user.id, nmn.id)
    UsersCheckNovels.link_to(user.id, mks.id)
    UsersCheckNovels.link_to(user.id, rzr.id)
    #UsersCheckNovels.link_to(tuser.id, sfo.id)
    #UsersCheckNovels.link_to(tuser.id, tsr.id)
    #UsersCheckNovels.link_to(tuser.id, rzr.id)

    UsersCheckNovels.switch_notification(user.id, sfo.id)
    UsersCheckNovels.switch_notification(user.id, mks.id)

    UsersCheckWriters.link_to(user.id, sfo.writer_id)
    UsersCheckWriters.link_to(user.id, rzr.writer_id)
    #UsersCheckWriters.link_to(tuser.id, sfo.writer_id)
    #UsersCheckWriters.link_to(tuser.id, tsr.writer_id)
  end

  def create_sfo_histries_date(novel_id) do
    sfo_episode_histries =
      [
        {20,"05","25","04","25"},
        {20,"05","27","10","00"},
        {20,"05","27","10","56"},
        {20,"05","27","12","03"},
        {20,"05","29","07","50"},
        {20,"06","01","05","49"},
        {20,"06","03","05","19"},
        {20,"06","05","11","51"},
        {20,"06","07","01","56"},
        {20,"06","14","01","53"}
      ]

    sfo_episode_histries
    |> Enum.map(fn {y, m, d, h, mi} -> "#{2000 + y}-#{m}-#{d} #{h}:#{mi}:00" end)
    |> Enum.with_index(708)
    |> Enum.each(fn {created, episode_id} ->
      NovelEpisodes.create(%{novel_id: novel_id, episode_id: episode_id, remote_created_at: created})
    end)
  end

  def delete_novel_leatest_episode() do
    novel_ncodes = ~w(n6169dz n6715cb n9078bd)
    from(
      ne in NovelEpisode,
      where: ne.id in subquery(
        from(
          ne in NovelEpisodes.novel_last_episodes_query,
          join: n in Novel,
          on: n.id == ne.novel_id,
          where: n.ncode in ^novel_ncodes,
          select: [:id]
        )
      )
    )
    |> Repo.delete_all
  end

  def create_befor_the_latest_episode do
    dummy_facts =
      [
        {"n9078bd", "2018-04-03 00:00:00"},
        {"n6316bn", "2015-12-30 19:49:00"},
        {"n6715cb", "2020-06-07 22:02:00"}
      ]

    dummy_facts
    |> Enum.each(fn {ncode, date} ->
      novel =
        from(
          n in Novel,
          where: n.ncode == ^ncode,
          limit: 1,
          preload: [last_episode: ^NovelEpisodes.novel_last_episodes_query]
        ) |> Repo.one()

      NovelEpisodes.create(
        %{
          novel_id: novel.id,
          episode_id: novel.last_episode.episode_id - 1,
          remote_created_at: date
        }
      )
    end)

  end

  def create_dummy_and_link(user_id, attr \\ %{}) do
    dummy_novel = Novels.create_with_assoc_episode(
      %{ncode: "n9999aaa", title: "dummy", writer_id: 1, remote_created_at: "2020-05-13 02:01:00", episode_id: 1} |> Map.merge(attr)
    )

    UsersCheckNovels.link_to(user_id, dummy_novel.id)
  end

  def create_dummy_notification_facts(user_id) do
    [
      %{type: :novel_new_episode,    novel_episode_id: 1},
      %{type: :new_post_novel,       novel_id:         1},
      %{type: :delete_novel,         novel_id:         1},
      %{type: :delete_novel_episode, novel_episode_id: 1},
      %{type: :delete_writer,        writer_id:        1}
    ]
    |> Enum.map(&(Map.merge(&1, %{user_id: user_id})))
    |> Enum.each(&NotificationFacts.create/1)
  end

  def delete_for_new_post_novel(writer_id) do
    IO.puts("start delete_for_new_post_novel")
    target = from(
      n in Novel,
      where: n.writer_id == ^writer_id,
      limit: 1,
      order_by: [desc: n.ncode],
      preload: [last_episode: ^NovelEpisodes.novel_last_episodes_query])
    |> Repo.one

    [target.last_episode, target]
    |> Enum.each(&Repo.delete/1)
  end
end

NarouBot.Seed.main()
:timer.sleep 3000
IO.gets "If you want to end it,just press any key!"

IO.puts "\nNarouBot.JobService.FetchWritersAndCreateNotificationFacts.exec"
