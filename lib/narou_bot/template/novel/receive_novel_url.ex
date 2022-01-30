defmodule NarouBot.Template.Novel.ReceiveNovelUrl do
  use NarouBot.Template
  alias LineBot.Message.Flex, as: F
  alias LineBot.Message, as: M
  import NarouBot.Template.Helper

  def render(:no_register, dao) do
    %{
      title: "未登録小説",
      actions: actions(:no_register, dao),
      date: format_date_yymmddhhmi(dao.novel.remote_created_at)
    } |> Map.merge(dao)
    |> _template()
  end

  def render(:registered_read_later, dao) do
    %{
      title: "後で読む小説",
      actions: actions(:registered_read_later, dao),
      date: format_date_yymmddhhmi(dao.novel.remote_created_at)
    } |> Map.merge(dao)
    |> _template()
  end

  def render(:registered_update_notify, dao) do
    %{
      title: "更新通知小説",
      actions: actions(:registered_update_notify, dao),
      date: format_date_yymmddhhmi(dao.novel.remote_created_at)
    } |> Map.merge(dao)
    |> _template()
  end

  def render(:no_data, _) do
    %M.Text{text: "存在しない小説か、作者によって検索除外に設定されています。"}
  end

  def actions(type, dao) do
    case type do
      :no_register ->
        [
          action(:read_later_add, dao)
        ] ++ (
          unless dao.novel.finished do
            [action(:update_notify_add, dao)]
          else
            []
          end
        )

      :registered_read_later ->
        [
          action(:read_later_update, dao),
          action(:read_later_delete, dao)
        ] ++ (
          unless dao.novel.finished do
            [action(:read_later_change, dao)]
          else
            []
          end
        )

      :registered_update_notify ->
        [
          action(:update_notify_delete, dao)
        ] ++ (
          unless dao.novel.finished do
            [action(:update_notify_change, dao)]
          else
            []
          end
        )
    end
  end

  defp action(:read_later_add, dao) do
    _action(%{action: "/novel/add", novel_id: dao.novel.id, episode_id: dao.episode_id, type: :read_later}, "後で読むに追加する")
  end

  defp action(:read_later_update, dao) do
    label = "再開位置更新 :  #{dao.old_episode_id} |> #{dao.episode_id}"
    _action(%{action: "/novel/update", novel_id: dao.novel.id, episode_id: dao.episode_id, type: :read_later}, label)
  end

  defp action(:read_later_delete, dao), do: _action(%{action: "/novel/delete", novel_id: dao.novel.id, type: :read_later}, "後で読むから削除する")
  defp action(:update_notify_add, dao), do: _action(%{action: "/novel/add", novel_id: dao.novel.id, type: :update_notify}, "更新通知に追加する")
  defp action(:read_later_change, dao), do: _action(%{action: "/novel/change_to_update_notify", novel_id: dao.novel.id}, "更新通知に変更する")
  defp action(:update_notify_change, dao), do: _action(%{action: "/novel/change_to_read_later", novel_id: dao.novel.id}, "後で読むに変更する")
  defp action(:update_notify_delete, dao), do: _action(%{action: "/novel/delete", novel_id: dao.novel.id, type: :update_notify}, "更新通知から削除する")

  defp _template(dao) do
    %F{
      altText: dao.title,
      contents: %F.Bubble{
        body: %F.Box{
          layout: :vertical,
          margin: :lg,
          spacing: :sm,
          contents: [
            %F.Text{
              align:  :center,
              size:   :xl,
              text:   dao.title,
              type:   :text,
              weight: :bold
            },
            %F.Box{
              layout: :vertical,
              margin: :lg,
              spacing: :sm,
              contents: [
                %F.Box{
                  layout: :baseline,
                  spacing: :sm,
                  contents: [
                    %F.Text{
                      align: :center,
                      color: "#666666",
                      size:  :md,
                      flex:  5,
                      text:  dao.novel.title,
                      wrap:  true
                    }
                  ]
                },
                %F.Box{
                  layout: :horizontal,
                  contents: [
                    %F.Text{
                      align: :center,
                      text:  "最終更新日 #{format_date_yymmddhhmi(dao.novel.remote_created_at)}",
                      wrap:  true
                    },
                    %F.Box{
                      layout: :vertical,
                      contents: [
                        %F.Text{
                          align:   :center,
                          gravity: :center,
                          text: novel_type(dao.novel)
                        },
                        %F.Text{
                          align:   :center,
                          gravity: :center,
                          text:    "最新話 #{dao.novel.episode_id}"
                        }
                      ]
                    }
                  ]
                },
                %F.Box{
                  layout: :horizontal,
                  contents: [
                    %F.Text{
                      align: :center,
                      text:  "総合 #{dao.novel_detail.total_point}P",
                    },
                    %F.Text{
                      align: :center,
                      text:  "#{dao.novel_detail.number_of_words}字",
                    },
                  ]
                }
              ]
            }
          ]
        },
        footer: %F.Box{
          flex: 0,
          layout: :vertical,
          spacing: :sm,
          contents: dao.actions
        }
      }
    }
  end

  def _action(data, label) do
    %F.Button{
      action: %M.Action.Postback{
        data: postback_data(data),
        label: label
      },
      height: :sm,
      style: :link
    }
  end

  def novel_type(novel) do
    cond do
      novel.is_short_story -> "短編"
      novel.finished       -> "完結"
      true                 -> "連載"
    end
  end
end
