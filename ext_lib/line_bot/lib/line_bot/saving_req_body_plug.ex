defmodule LineBot.SavingReqBodyPlug do
  import Plug.Conn
  require Logger

  @behaviour Plug
  @moduledoc false

  @impl true
  def init(_opts), do: []

  @impl true
  def call(conn, opts) do
    case Plug.Conn.read_body(conn, opts) do
      {:ok, body, conn} ->
        put_private(conn, :line_bot_raw_body, body)

      {:more, _body, _conn} ->
        raise Plug.BadRequestError

      {:error, :timeout} ->
        raise Plug.TimeoutError

      {:error, _} ->
        raise Plug.BadRequestError
    end
  end
end
