defmodule NarouBot.Command.Novel.Delete do
  use NarouBot.Command
  alias NarouBot.Repo.{Novels, UsersCheckNovels}
  alias NarouBot.Command.Novel.Helper.UserCallableState

  def call(param) do
    user = current_user(param)
    novel = Novels.find(param.data.novel_id)
    type = param.data.type

    export novel: novel, type: type

    case UserCallableState.judge(type, :delete, %{user_id: user.id, novel_id: novel.id}) do
      {:error} -> render_with_send :error
      {:ok}    ->
        UsersCheckNovels.unlink_to(user.id, novel.id)
        render_with_send :ok
    end
  end
end
