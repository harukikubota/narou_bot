defmodule NarouBot.Command.MessageServer do
  use Agent

  use Agent

  def start_link(target_pid, reply_token) do
    {:ok, pid} = Agent.start_link(fn -> default_record() end, name: to_key_name(target_pid))

    memo_self_pid(pid, target_pid)
    set_reply_token(target_pid, reply_token)

    {:ok, pid}
  end

  defp default_record, do: %{messages: [], reply_token: nil, dao: %{}, self: nil}
  defp memo_self_pid(self_pid, target_pid), do: update_property(target_pid, :self, fn _ -> self_pid end)

  def get_messages(pid),    do: get_property(pid, :messages)
  def get_reply_token(pid), do: get_property(pid, :reply_token)
  def get_dao(pid),         do: get_property(pid, :dao)
  defp get_self(pid),         do: get_property(pid, :self)

  defp get_property(pid, key), do: Agent.get(to_key_name(pid), &(Map.get(&1, key)))

  def push_message(pid, messages) do
    update_property(pid, :messages, &(&1 ++ List.wrap(messages)))
  end

  def push_val(pid, val_name, val) do
    update_property(pid, :dao, &(Map.merge(&1, %{val_name => val})))
  end

  defp set_reply_token(pid, reply_token) do
    update_property(pid, :reply_token, fn _-> reply_token end)
  end

  defp update_property(pid, update_target_key, update_fun) do
    Agent.update(to_key_name(pid), &(Map.replace!(&1, update_target_key, update_fun.(Map.get(&1, update_target_key)))))
  end

  def stop(pid), do: pid |> get_self() |> Agent.stop()

  def to_key_name(pid) do
    to_key_symbol = fn pid_str -> :"p#{pid_str}" end

    pid
    |> inspect
    |> String.slice(7..-4)
    |> to_key_symbol.()
  end
end
