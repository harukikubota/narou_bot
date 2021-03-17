defmodule NarouBot.Command.MessageServer do
  @behaviour GenServer

  defstruct [:target_pid, :token, bindings: %{}, messages: []]

  defmacrop to_key_name(pid) do
    quote bind_quoted: [pid: pid] do
      inspect(pid)
      |> String.slice(7..-4)
      |> (&(:"p#{&1}")).()
    end
  end

  def start_link(pid, reply_token) do
    opt = [target_pid: pid, token: reply_token]

    GenServer.start_link(__MODULE__, opt, name: to_key_name(pid))
  end

  def get_reply_token(pid), do: GenServer.call(to_key_name(pid), :token)

  def get_messages(pid),    do: GenServer.call(to_key_name(pid), :messages) |> Enum.reverse

  def get_dao(pid),         do: GenServer.call(to_key_name(pid), :bindings)

  def push_val(pid, var_name, val), do: GenServer.cast(to_key_name(pid), {:push_binding, {var_name, val}})

  def push_message(pid, message), do: GenServer.cast(to_key_name(pid), {:push_message, message})

  def stop(pid),            do: GenServer.stop(to_key_name(pid), :normal)

  @impl true
  def init(target_pid: target_pid, token: token) do
    state = %__MODULE__{
              target_pid: to_key_name(target_pid),
              token: token
            }

    {:ok, state}
  end

  @impl true
  def handle_call(key, _, state) when is_atom(key) do
    {:reply, Map.fetch!(state, key), state}
  end

  @impl true
  def handle_cast({:push_binding, {var_name, val}}, state = %{bindings: bindings}) do
    {:noreply, %{state | bindings: Map.merge(bindings, %{var_name => val})}}
  end

  def handle_cast({:push_message, message}, state = %{messages: messages}) do
    {:noreply, %{state | messages: [message | messages] |> Enum.flat_map(&(&1))}}
  end
end
