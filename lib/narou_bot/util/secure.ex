defmodule NarouBot.Util.Secure do
  def admin_id_to_hash(admin_userid) do
    :crypto.hash(:sha256, admin_userid)
    |> :binary.decode_unsigned()
  end
end
