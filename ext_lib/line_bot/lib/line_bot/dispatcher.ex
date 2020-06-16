defmodule LineBot.Dispatcher do
  @moduledoc false

  def dispatch_events([], _destination, _callback), do: :ok

  def dispatch_events([event | events], destination, callback) do
    dispatch_event(event, destination, callback)
    dispatch_events(events, destination, callback)
  end

  defp dispatch_event(event, destination, callback) do
    event = each_key_to_atom(event)
    event = unless Map.has_key?(event, :reply_token), do: Map.merge(event, %{reply_token: ""}), else: event
    info = %LineBot.EventInfo{
      user_id: event.source.user_id,
      reply_token: event.reply_token,
      source: event.source,
      destination: destination,
      timestamp: DateTime.from_unix!(event.timestamp, :millisecond)
    }

    async(callback, handler(String.to_atom(event.type), event, info))
  end

  defp async(callback, {function, args}) do
    Task.Supervisor.start_child(LineBot.TaskSupervisor, fn -> apply(callback, function, args) end)
  end

  defp handler(:message, event, info) do
    {:handle_message, [event.message, info]}
  end

  defp handler(:postback, event, info) do
    data = event.postback.data
    |> String.split("&")
    |> Enum.map(&(String.split(&1, "=")))
    |> Enum.map(&({String.to_atom(hd(&1)), List.last(&1)}))
    |> Map.new
    {:handle_postback, [data, info]}
  end

  defp handler(:member_joined, event, info) do
    {:handle_member_joined, [event.joined.members, info]}
  end

  defp handler(:member_left, event, info) do
    {:handle_member_left, [event.left.members, info]}
  end

  defp handler(:beacon, event, info) do
    {:handle_beacon, [event.beacon, info]}
  end

  defp handler(:account_link, event, info) do
    {:handle_account_link, [event.link, info]}
  end

  defp handler(:things, event, info) do
    {:handle_things, [event.things, info]}
  end

  defp handler(type, _event, info) do
    {"handle_" <> to_string(type) |> String.to_atom, [info]}
  end

  #defp handler(type, event, info) do
  #  {:handle_other, [type, event, info, event["replyToken"]]}
  #end

  defp each_key_to_atom(event) do
    event
    |> Map.keys
    |> Enum.map(&(Macro.underscore(&1)))
    |> Enum.map(&(String.to_atom(&1)))
    |> Enum.zip(Enum.map(Map.values(event), &(if is_map(&1), do: each_key_to_atom(&1), else: &1)))
    |> Map.new
  end
end
