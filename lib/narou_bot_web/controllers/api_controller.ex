defmodule NarouBotWeb.ApiController do
  use NarouBotWeb, :controller
  require Logger

  def dump(conn, _params) do
    body = conn.private.body
    Logger.info body: body
    case NarouBot.RestoreServer.verify_key(:dump, body["key"]) do
      :error -> raise "failed verify key."
      _ -> nil
    end

    put_view(conn, NarouBotWeb.Views.ApiView)
    |> render("dump.json")
  end

  @spec restore(Plug.Conn.t(), %{key: any}) :: Plug.Conn.t()
  def restore(conn, params) do
    NarouBot.RestoreServer.verify_key(:restore, params.restore_key)
    |> do_restore()
    text(conn, "ok")
  end

  defp do_restore(:ok) do

  end

  defp do_restore(:error) do

  end
end
