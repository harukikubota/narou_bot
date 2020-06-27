defmodule NarouBot.Command.Novel.ShowUpdateHistory do
  use NarouBot.Command
  alias NarouBot.Repo.{Novels, NovelEpisodes}

  def call(param) do
    export novel: Novels.find(param.data.novel_id),
      history: NovelEpisodes.leatest_update_history(param.data.novel_id)
    render_with_send :ok
  end
end
