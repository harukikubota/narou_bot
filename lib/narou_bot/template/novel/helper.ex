defmodule NarouBot.Template.Novel.Helper do
  def make_novel_url(ncode, episode_id \\ nil) do
    url = "https://ncode.syosetu.com/" <> ncode

    if ncode, do: url <> "/#{episode_id}", else: url
  end

  def notification_flag_to_jp(flag) do
    if flag, do: "オン", else: "オフ"
  end

  def check_type_to_jp("update_notify"), do: "更新通知"
  def check_type_to_jp("read_later"),    do: "後で読む"
end
