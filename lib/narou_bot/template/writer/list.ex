defmodule NarouBot.Template.Writer.List do
  use NarouBot.Template
  alias LineBot.Message, as: M
  alias LineBot.Message.Flex, as: F
  alias NarouBot.Template.Writer.Show, as: ColTemplate

  def render(:no_registered, _), do: %M.Text{text: "更新通知に登録している作者が存在しません。\n\n追加するには作者マイページのURLを送信してください。"}

  def render(:ok, %{writers: writers}) do
    writers
    |> Enum.chunk_every(10)
    |> Enum.map(&col_template/1)
  end

  def col_template(writers) do
    %F{
      altText: "登録作者一覧",
      contents: %F.Carousel{
        contents: Enum.map(writers, &make_writer_info/1)
      }
    }
  end

  def make_writer_info(writer), do: ColTemplate.template(:ok, writer)
end
