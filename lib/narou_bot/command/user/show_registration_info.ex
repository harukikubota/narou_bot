defmodule NarouBot.Command.User.ShowRegistrationInfo do
  use NarouBot.Command
  alias NarouBot.Repo.{
    UsersCheckNovels,
    UsersCheckWriters
  }

  def call(param) do
    user = current_user(param)

    export novel_register_max:    user.novel_register_max,
      writer_register_max:        user.writer_register_max,
      novel_read_later_count:     UsersCheckNovels.user_register_count("read_later", user.id),
      novel_update_notify_count:  UsersCheckNovels.user_register_count("update_notify", user.id),
      writer_update_notify_count: UsersCheckWriters.user_register_count(user.id)

    render_with_send :ok
  end
end
