defmodule NarouBot.Command.Novel.ReceiveNovelUrl do
  use NarouBot.Command
  alias NarouBot.Repo.{Narou, Novels, Users, UsersCheckNovels}

  def setup(param) do
    %{global_point: total_point, length: number_of_words} = Narou.novel_detail(param.ncode)

    %{novel_detail: %{total_point: total_point, number_of_words: number_of_words}}
    |> Map.merge(param)
  end

  def call(param) do
    type =
      case Novels.find_or_create_by(param.ncode) do
        {:no_data}   -> render_with_send :no_data
        {:ok, novel} ->
          user = Users.find_by_line_id(param.user_id)
          episode_id = if param.episode_id == "", do: 1, else: param.episode_id
          export novel: novel, episode_id: episode_id, novel_detail: param.novel_detail

          if UsersCheckNovels.registered?(user.id, novel.id, :update_notify) do
            :registered_update_notify
          else
            record = UsersCheckNovels.find(user.id, novel.id, :read_later)
            unless is_nil(record) do
              export old_episode_id: record.restart_episode_id

              :registered_read_later
            else
              :no_register
            end
          end
      end

    render_with_send type
  end
end
