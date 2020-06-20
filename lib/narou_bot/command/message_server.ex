defmodule NarouBot.Command.MessageServer do
  use Agent

  def start_link(token) do
    Agent.start_link(fn -> %{messages: [], token: token} end)
  end

  def get_messages(pid),    do: Agent.get(pid, &(Map.get(&1, :messages)))
  def get_reply_token(pid), do: Agent.get(pid, &(Map.get(&1, :token)))

  def push(messages, key) do
    Agent.update(key, &(Map.replace!(&1, :messages, Map.get(&1, :messages) ++ List.wrap(messages))))
  end

  def stop(pid), do: Agent.stop(pid)
end
