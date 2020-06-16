defmodule LineBot.Webhook do
  require Logger

  #alias LineBot.Webhook
  #Webhook.init conn: conn, router: NarouBot.Router
  #|> Webhook.validate_signature()
  #|> Webhook.routing_events()

  # RequestLogger挟む
  #

  def init(opts) do
    with conn = Keyword.fetch(opts, :conn),
          router = Keyword.fetch(opts, :router) do
      {:ok, router} ->router
      :error -> raise "Must provide router module: LineBot.Webhook, router: YourRouterModule"
    end
  end



  defp dispatch_events(
         %Plug.Conn{
           body_params: %{
             "events" => [%{"source" => %{"userId" => "Udeadbeefdeadbeefdeadbeefdeadbeef"}} | _]
           }
         } = conn
       ) do
    Logger.debug("handled webhoook verify request")
    send_resp(conn, :ok, "")
  end

  defp dispatch_events(
         %Plug.Conn{
           private: %{line_bot_callback: callback},
           body_params: %{"destination" => destination, "events" => events}
         } = conn
       ) do
    Task.Supervisor.start_child(LineBot.TaskSupervisor, fn ->
      LineBot.Dispatcher.dispatch_events(events, destination, callback)
    end)

    send_resp(conn, :ok, "")
  end

  defp dispatch_events(%Plug.Conn{private: %{line_bot_raw_body: request}} = conn) do
    Logger.warn("Unrecognised request: #{request}")
    send_resp(conn, :bad_request, "Unrecognised request")
  end

  defp dispatch_events(conn) do
    IO.inspect conn
  end

  defp check_not_already_parsed(%Plug.Conn{body_params: %Plug.Conn.Unfetched{}} = conn, _opts) do
    conn
  end

  defp check_not_already_parsed(conn, _opts) do
    Logger.error("Request must not be parsed by Plug.Parsers before reaching LineBot.Webhook")

    conn
    |> send_resp(:internal_server_error, "Body parsed before reaching Line Bot Webhook")
    |> halt()
  end

  defp put_callback(conn, callback), do: put_private(conn, :line_bot_callback, callback)
end
