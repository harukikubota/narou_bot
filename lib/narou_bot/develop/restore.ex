defmodule NarouBot.Develop.Restore do
  alias NarouBot.Repo
  @users ["Uc043bb4602f875df9d19e266c67d0f57", "Ud8a9ce42be861a9b5811552bf716fb6d"]
  def new_user(user_line_ids) do
    Enum.each(user_line_ids, &Repo.Users.new_user/1)
  end

  def main() do

    new_user(@users)
    body = load_restore_data()

    rest_writer(body)
    await(15000)
    rest_novel_episodes(body)
    await()
    rest_user_register_novels(body)
    await()
    rest_user_register_writers(body)
  end

  #defp load_restore_data() do
  #  Application.app_dir(:narou_bot)
  #  |> Path.split
  #  |> Enum.slice(0..-5)
  #  |> Kernel.++(["tmp", "dump.json"])
  #  |> Path.join
  #  |> File.read
  #  |> elem(1)
  #  |> Jason.decode
  #  |> elem(1)
  #end

  defp load_restore_data() do
    NarouBot.RestoreServer.get_rest_data()
  end

  defp await(stop_time \\ 1000) do
    :timer.sleep(stop_time)
  end

  defp rest_writer(%{"fetch_writer_ids" => ids}) do
    Enum.each(ids, &Repo.Writers.find_or_create_by/1)
  end

  defp rest_novel_episodes(%{"novel_episodes" => nes}) do
    Enum.each(nes, fn %{"episodes" => episodes, "ncode" => ncode} ->
      novel = Repo.Novels.find_by_ncode(ncode)
      Enum.each(episodes, &create_novel_episode(novel.id, &1))
    end)
  end

  defp rest_user_register_novels(%{"user_register_novels" => ns}) do
    alias Repo.UsersCheckNovels, as: N
    Enum.each(ns, fn user_i ->
      [{user_id, novels}] = Map.to_list(user_i)
      user_id = String.to_integer(user_id)
      Enum.each(novels, fn novel ->
        r_novel = Repo.Novels.find_by_ncode(novel["ncode"])
        case novel["type"] do
          "update_notify" ->
            N.link_to(user_id, r_novel.id)

            # FIXME 現在は通知無しがないのでやらない
            #unless novel.do_notify do
            #  N.switch_notification(user_id, r_novel.id, novel.turn_off_notification_at)
            #end
          "read_later" ->
            N.link_to(user_id, r_novel.id, novel["restart_episode_id"])
          _ -> raise "@rest_user_register_novels. errors"
        end
      end)
    end)
  end

  defp rest_user_register_writers(%{"user_register_writers" => ws}) do
    alias Repo.UsersCheckWriters, as: W
    Enum.each(ws, fn {user_id, writers} ->
      user_id = String.to_integer(user_id)

      Enum.each(writers, fn remote_id ->
        writer = Repo.Writers.find_by_remote_id(remote_id)
        W.link_to(user_id, writer.id)
      end)
    end)
  end

  defp create_novel_episode(novel_id, %{"episode_id" => episode_id, "created_at" => created_at}) do
    Repo.NovelEpisodes.create(
      %{
        novel_id: novel_id,
        episode_id: episode_id,
        remote_created_at: unix_to_jp_date(created_at)
      }
    )
  end

  defp unix_to_jp_date(unix_time) do
    DateTime.from_unix(unix_time)
    |> elem(1)
    |> DateTime.add(3600 * 9)
    |> inspect
    |> String.slice(3..-3)
  end
end
