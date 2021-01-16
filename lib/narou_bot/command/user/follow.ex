defmodule NarouBot.Command.User.Follow do
  use NarouBot.Command
  alias NarouBot.Repo.Users

  def call(param) do
    type = case Users.find_or_create_by(param.user_id) do
      {:ok, _}      -> :hello
      {:created, user} ->
        Users.enable_to(user)
        :welcome_back
    end

    render_with_send type
  end
end
