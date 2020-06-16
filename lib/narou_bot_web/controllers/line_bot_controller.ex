defmodule NarouBotWeb.LineBotController do
  use SampleWeb, :controller

  def callback(conn, %{"events" => events}) do
    %{"message" => message } = List.first(events)
    %{"source" => source } = List.first(events)
    events = List.first(events)
    endpoint_uri = "https://api.line.me/v2/bot/message/reply"

    json_data = %{
      replyToken: events["replyToken"],
      messages: [
        %{
        type: "text",
        text: message["text"] # 受信したメッセージをそのまま返す
        }
      ]
    } |> Poison.encode!

    headers = %{
      "Content-Type" => "application/json",
      "Authorization" => "Bearer ${アクセストークン}"   #MessagingAPI設定|>チャネルアクセストークンからアクセストークンを取得
    }

    case HTTPoison.post(endpoint_uri, json_data, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts body
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        IO.puts "Not found :("
      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.inspect reason
    end

    send_resp(conn, :no_content, "")
  end
end
