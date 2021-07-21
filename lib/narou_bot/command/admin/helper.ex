defmodule NarouBot.Command.Admin.Helper do
  def is_admin(param) do
    left = NarouBot.Util.Secure.admin_id_to_hash(param.user_id)
    right = System.get_env("ADMIN_USER_ID") |> String.to_integer()

    left == right
  end
end
