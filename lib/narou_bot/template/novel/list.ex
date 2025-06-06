defmodule NarouBot.Template.Novel.List do
  use NarouBot.Template
  alias LineBot.Message, as: M
  alias LineBot.Message.Flex, as: F
  alias NarouBot.Template.Novel.Show, as: ColTemplate
  import NarouBot.Template.Novel.Helper

  def render(:no_registered, %{type: type}), do: %M.Text{text: "#{check_type_to_jp(type)}に登録している小説が存在しません。\n\n追加するにはなろう小説のURLを送信してください。"}

  def render(:ok, dao) do
    dao.novels
    |> Enum.chunk_every(10)
    |> Enum.map(&col_template(&1, dao.type))
  end

  def col_template(novels, type) do
    %F{
      altText: "登録小説一覧",
      contents: %F.Carousel{
        contents: Enum.map(novels, &make_novel_info(&1, type))
      }
    }
  end

  defp make_novel_info(novel, type) do
    ColTemplate.template(%{novel: novel, type: type})
  end
end
