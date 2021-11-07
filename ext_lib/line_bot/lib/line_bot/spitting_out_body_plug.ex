defmodule LineBot.SpittingOutBodyPlug do
  import Plug.Conn
  require Logger

  @behaviour Plug
  @moduledoc false

  @impl true
  def init(_opts), do: []

  @impl true
  def call(conn, opts) do
    {:ok, body} = Jason.decode(conn.private.line_bot_raw_body)
    put_private(conn, :body, body)
  end
end
