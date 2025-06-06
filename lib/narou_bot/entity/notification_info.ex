import EctoEnum

defenum NarouBot.Entity.NotificationInfo.NotificationStatus,
  inserted:    0,
  job_touch:   1,
  notificated: 2,
  user_unread: 3,
  error:       4

defenum NarouBot.Entity.NotificationInfo.NotificationType,
  novel_new_episode:    "novel_new_episode",
  new_post_novel:       "new_post_novel",
  delete_novel:         "delete_novel",
  delete_novel_episode: "delete_novel_episode",
  delete_writer:        "delete_writer"

defmodule NarouBot.Entity.NotificationInfo do
  use Ecto.Schema
  import Ecto.Changeset
  alias NarouBot.Entity.{
    User,
    Novel,
    NovelEpisode,
    Writer,
    NotificationInfo
  }
  alias NarouBot.Entity.NotificationInfo.{
    NotificationStatus,
    NotificationType
  }

  @default_status NotificationStatus.__enum_map__() |> List.first |> elem(1)

  # TODO 削除バッチを動かせるようにする
  # 外部参照をはずさずに消したいけど、リファレンスエラー出るから消す必要ありそう。。。
  schema "notification_facts" do
    belongs_to :user,          User
    belongs_to :novel,         Novel
    belongs_to :novel_episode, NovelEpisode
    belongs_to :writer,        Writer

    field      :status,        NotificationStatus, default: @default_status
    field      :type,          NotificationType
    field      :error_reason,  :string
    timestamps()
  end

  def changeset(model \\ %NotificationInfo{}, type, attr) do
    params = params(:common) ++ params(type)
    model
    |> cast(attr, params)
    |> set_type(type)
    |> validate_required(params)
  end

  defp set_type(ch, type) do
    ch |> put_change(:type, type)
  end

  defp params(:common),               do: [:user_id, :type]
  defp params(:novel_new_episode),    do: [:novel_episode_id]
  defp params(:new_post_novel),       do: [:novel_id]
  defp params(:delete_novel),         do: [:novel_id]
  defp params(:delete_novel_episode), do: [:novel_episode_id]
  defp params(:delete_writer),        do: [:writer_id]
end
