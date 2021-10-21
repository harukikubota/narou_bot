defmodule NarouBot.Develop.Dumper do
  # ローカルのアクセスURLを受け取る
  # データ送信
  # 終わり
  #
  #

  @behaviour GenServer
  defstruct [:url]
  def main(local_url) do
    send_url = local_server(local_url)

    HTTPoison.post(send_url, send_data())
  end

  def local_server(url) do
    url <> "/dump/receive"
  end

  defp send_data do
    {:ok, send_data} = %{k: 1} |> Jason.encode()
    send_data
  end
end
