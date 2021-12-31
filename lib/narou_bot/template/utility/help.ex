defmodule NarouBot.Template.Utility.Help do
  use NarouBot.Template
  alias LineBot.Message, as: M
  alias LineBot.Message.Flex, as: F
  import NarouBot.Template.Helper

  def render(:mitaiou, _) do
    %M.Text{text: "ヘルプは未実装です。しばしお待ちを。。。。"}
  end

  def render("list", _) do
    %F{
      altText: "ヘルプ 一覧",
      contents: %F.Carousel{
        contents: Enum.map(
                    [
                      {"receive_novel-writer_url", "小説／作者の登録", "小説／作者のURLを送信することで、登録／削除／更新が行えます。"}
                    ],
                    &help_list/1
                  )
      }
    }
  end

  defp help_list(title, description, actions) do
    %F.Bubble{
      body: %F.Box{
        layout: :vertical,
        contents: [
          %F.Text{
            text: title,
            weight: :bold,
            size: :xl,
            align: :center
          },
          %F.Text{
            text: description,
            wrap: true
          }
        ]
      },
      footer: %F.Box{
        layout: :vertical,
        contents: make_action_boxes(actions)
      }
    }
  end

  defp make_action_boxes(actions) do
    actions
    |> Enum.chunk_every(2)
    |> Enum.map(&make_row_box/1)
  end

  defp make_row_box(actions) do
    %F.Box{
      layout: :horizontal,
      contents: actions
    }
  end

  defp help_list({type, title, description}) do
    help_list(title, description, actions(type))
  end

  defp actions("receive_novel-writer_url") do
    [
      action("未登録小説",   "novel/no_registered"),
      action("未登録作者",   "writer/no_registered"),
      action("更新通知小説", "novel/update_notify"),
      action("後で読む小説", "novel/read_later"),
    ]
  end

  defp action(label, show_type) do
    %F.Button{
      action: %M.Action.Postback{
        data: postback_data(%{action: "/utility/help", show_type: show_type}),
        label: label
      }
    }
  end
end
