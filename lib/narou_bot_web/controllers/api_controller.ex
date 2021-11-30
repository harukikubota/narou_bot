defmodule NarouBotWeb.ApiController do
  use NarouBotWeb, :controller
  require Logger

  def dump(conn, _params) do
    body = conn.private.body
    case NarouBot.RestoreServer.verify_key(:dump, body["key"]) do
      :error -> raise "failed verify key."
      _ -> nil
    end

    put_view(conn, NarouBotWeb.Views.ApiView)
    |> render("dump.json")
  end

  def rest(conn, _params) do
    body = conn.private.body
    NarouBot.RestoreServer.verify_key(:restore, body["key"])
    NarouBot.RestoreServer.set_restore_data(body["data"])
    text(conn, "ok")
  end
end
