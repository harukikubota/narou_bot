defmodule NarouBot.Command.Helper do
  alias NarouBot.Repo.Users

  defmacro current_user(param) do
    quote bind_quoted: [param: param], do: Users.find_by_line_id(param.user_id)
  end
end
