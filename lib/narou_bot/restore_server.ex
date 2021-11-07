defmodule NarouBot.RestoreServer do
  @behaviour GenServer

  defstruct [:mode , :restore_key, :dump_key, :restore_data]

  defguard permitted_mode?(mode) when mode in [:dump, :restore]

  def start_link(mode) when permitted_mode?(mode) do
    GenServer.start_link(__MODULE__, [mode: mode], name: __MODULE__)
  end

  def verify_key(mode, key) when permitted_mode?(mode) do
    message =
      to_key_name(mode)
      |> to_string()
      |> then(&Kernel.<>("verify_", &1))
      |> String.to_atom()

    GenServer.call(__MODULE__, {message, key})
  end

  def get_key(mode) when permitted_mode?(mode) do
    GenServer.call(__MODULE__, mode)
  end

  defp to_key_name(mode) do
    case mode do
      :dump -> :dump_key
      :restore -> :restore_key
    end
  end

  defp new(mode) do
    %__MODULE__{mode: mode}
    |> Map.merge(%{to_key_name(mode) => gen_rand_key()})
  end

  defp gen_rand_key do
    :rand.normal
    |> abs
    |> to_string
    |> String.slice(2..-1)
    |> then(&:crypto.hash(:sha, &1))
    |> Base.encode64
  end

  @impl true
  def init(mode: mode) do
    {:ok, new(mode)}
  end

  @impl true
  def handle_call({:verify_dump_key, left_key}, _, %__MODULE__{mode: :dump, dump_key: right_key} = state) do
    ret = if(left_key == right_key, do: :ok, else: :error)

    {:reply, ret, state}
  end

  def handle_call({:verify_dump_key, _}, _, state) do
    raise "#{__MODULE__} is not dump mode."
    {:reply, {:error, nil}, state}
  end

  # key取得
  def handle_call(mode, _, state) when permitted_mode?(mode) do
    key = Map.get(state, to_key_name(mode))

    {:reply, key, state}
  end
end
