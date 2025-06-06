# 未登録／更新通知登録済／後で読む登録済／全通知用の構造体を受け取るようにする。
# 各モジュールが構造体を生成する。    

defmodule NarouBot.Template.Novel.Show do
  use NarouBot.Template
  alias LineBot.Message, as: M
  alias LineBot.Message.Flex, as: F
  import NarouBot.Template.Helper
  alias NarouBot.Template.Novel.Helper, as: NHelper

  def render(:ok, dao) do
    %F{
      altText: dao.novel.title,
      contents: template(dao)
    }
  end

  def template(dao) do
    %F.Bubble{
      header: header(dao.novel),
      body: body(dao.type, dao.novel),
      footer: footer(dao.type, dao.novel),
      styles: %F.BubbleStyle{
        body: %F.BubbleStyleBlock{ separator: true, separatorColor: "#020202" },
        footer: %F.BubbleStyleBlock{ separator: true, separatorColor: "#020202" }
      }
    }
  end

  def header(novel) do
    %F.Box{
      layout: :vertical,
      contents: [
        %F.Text{
          text: novel.title,
          color: "#325b85",
          align: :center
        }
      ],
      action: %M.Action.URI{
        uri: add_opt_open_url_link(NHelper.make_novel_url(novel.ncode))
      }
    }
  end

  def body("update_notify", novel) do
    body = %F.Box{
      layout: :vertical,
      contents: [
        novel_writer(novel),
        latest_episode_info(novel)
      ]
    }

    with {:ok, ch} <- Map.fetch(novel, :check_user), false <- ch.do_notify do
      Map.update!(body, :contents, &(&1 ++ [box_unread_count(novel)]))
    else
      _ -> body
    end
  end

  def body("read_later", novel) do
    %F.Box{
      layout: :vertical,
      contents: [
        novel_writer(novel),
        restart_episode_info(novel)
      ]
    }
  end

  def novel_writer(novel) do
    %F.Box{
      layout: :vertical,
      contents: [
        %F.Button{
          action: %M.Action.Postback{
            data: postback_data(%{action: "/writer/show", writer_id: novel.writer_id}),
            label: truncate_str(novel.writer.name)
          }
        }
      ]
    }
  end

  def latest_episode_info(novel) do
    %F.Box{
      layout: :horizontal,
      contents: [
        %F.Text{
          text: "最新話 #{novel.last_episode.episode_id}",
          action: %M.Action.URI{
            uri: add_opt_open_url_link(NHelper.make_novel_url(novel.ncode, novel.last_episode.episode_id))
          },
          color: "#325b85",
          flex: 5
        },
        %F.Text{
          text: format_date_yymmddhhmi(novel.last_episode.remote_created_at),
          flex: 7
        }
      ]
    }
  end

  def box_unread_count(novel) do
    %F.Box{
      layout: :horizontal,
      contents: [
        %F.Text{
          text: "未読件数  #{novel.unread_count}",
          align: :center
        }
      ]
    }
  end

  def restart_episode_info(novel) do
    %F.Box{
      layout: :horizontal,
      contents: [
        %F.Text{
          text: "#{novel.check_user.restart_episode_id}話  #{format_date_yymmddhhmi(novel.check_user.updated_at)}",
          align: :center
        }
      ]
    }
  end

  def footer(type, novel) do
    %F.Box{
      layout: :vertical,
      contents: [footer_top_area(type, novel), footer_bottom_area(type, novel)] |> Enum.reject(&is_nil/1)
    }
  end

  def footer_top_area("update_notify", novel) do
    contents =
      if novel.check_user.do_notify do
        [button_show_update_history(novel.id)]
      else
        [button_show_update_history(novel.id),button_show_user_unread_episode(novel.id)]
      end
    %F.Box{
      layout: :horizontal,
      contents: contents
    }
  end

  def footer_top_area("read_later", novel) do
    %F.Box{
      layout: :horizontal,
      contents: [
        %F.Button{
          action: %M.Action.URI{
            uri: add_opt_open_url_link(NHelper.make_novel_url(novel.ncode, novel.check_user.restart_episode_id)),
            label: "再開する"
          }
        },
        button_novel_delete(novel.id, "read_later")
      ]
    }
  end

  def footer_bottom_area("update_notify", novel) do
    %F.Box{
      layout: :horizontal,
      contents: [
        %F.Button{
          action: %M.Action.Postback{
            data: postback_data(%{action: "/novel/switch_notification", novel_id: novel.id}),
            label: "通知" <> NHelper.notification_flag_to_jp(!novel.check_user.do_notify)
          }
        },
        button_novel_delete(novel.id, "update_notify")
      ]
    }
  end

  def footer_bottom_area("read_later", _), do: nil

  def button_novel_delete(novel_id, type) do
    %F.Button{
      action: %M.Action.Postback{
        data: postback_data(%{action: "/novel/delete", novel_id: novel_id, type: type}),
        label: "削除する"
      }
    }
  end

  def button_show_update_history(novel_id) do
    %F.Button{
      action: %M.Action.Postback{
        data: postback_data(%{action: "/novel/show_update_history", novel_id: novel_id}),
        label: "更新履歴"
      }
    }
  end

  def button_show_user_unread_episode(novel_id) do
    %F.Button{
      action: %M.Action.Postback{
        data: postback_data(%{action: "/novel/show_user_unread_episode", novel_id: novel_id, confirm: true}),
        label: "未読を読む"
      }
    }
  end
end
