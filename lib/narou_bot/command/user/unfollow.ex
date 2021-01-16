defmodule NarouBot.Command.User.Unfollow do
  use NarouBot.Command
  alias NarouBot.Repo.Users

  def call(param), do: Users.disable_to(current_user(param))
end
