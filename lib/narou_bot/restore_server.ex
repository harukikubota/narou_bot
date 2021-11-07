defmodule NarouBot.RestoreServer do
  @behaviour GenServer
  require Logger
  #NarouBot.RestoreServer.do_restore
#GenServer.stop(NarouBot.RestoreServer)
#GenServer.call(NarouBot.RestoreServer, :debug)
  defstruct [:mode , :restore_key, :dump_key, :verified, :restore_data]

  defguard permitted_mode?(mode) when mode in [:dump, :restore]

  def start_link(mode) when permitted_mode?(mode) do
    self = GenServer.start_link(__MODULE__, [mode: mode], name: __MODULE__)

    spawn(__MODULE__, :tick, [])

    self
  end

  def tick() do
    Process.sleep(1000)
    a = GenServer.call(__MODULE__, :alive?)
    self = GenServer.call(__MODULE__, :debug)
    Logger.debug alive?: a, mode: self.mode, verified: self.verified

    tick()
  end

  def verify_key(mode, key) when permitted_mode?(mode) do
    message =
      to_key_name(mode)
      |> to_string()
      |> then(&Kernel.<>("verify_", &1))
      |> String.to_atom()

    ret = GenServer.call(__MODULE__, {message, key})

    verified =
      case ret do
        :ok -> true
        :error -> false
      end

    set_verified(verified)

    ret
  end

  def get_key(mode) when permitted_mode?(mode) do
    GenServer.call(__MODULE__, mode)
  end

  defp set_verified(state) do
    GenServer.call(__MODULE__, {:set_verified, state})
  end

  def set_restore_data(json_obj) do
    GenServer.call(__MODULE__, {:set_restore_data, json_obj})
  end

  def do_restore() do
    unless verified?() do
      raise "Can't start restore."
    end

    NarouBot.Develop.Restore.main()
  end

  def get_rest_data do
    GenServer.call(__MODULE__, :get_restore_data)
  end

  def close() do
    GenServer.stop(__MODULE__)
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

  defp verified? do
    GenServer.call(__MODULE__, :verified?)
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
    {:reply, :error, state}
  end

  def handle_call({:verify_restore_key, left_key}, _, %__MODULE__{mode: :restore, restore_key: right_key} = state) do
    Logger.debug l: left_key, r: right_key, t: left_key == right_key
    ret = if(left_key == right_key, do: :ok, else: :error)

    {:reply, ret, state}
  end

  def handle_call({:verify_restore_key, _}, _, state) do
    raise "#{__MODULE__} is not restore mode."
    {:reply, :error, state}
  end

  # key取得
  def handle_call(mode, _, state) when permitted_mode?(mode) do
    key = Map.get(state, to_key_name(mode))

    {:reply, key, state}
  end

  def handle_call({:set_restore_data, json_obj}, _, state) do
    {:reply, :ok, %{state | restore_data: json_obj}}
  end

  def handle_call({:set_verified, verified}, _, state) do
    Logger.debug("verified key: #{verified}")
    {:reply, :ok, %{state | verified: verified}}
  end

  def handle_call(:get_restore_data, _, %{restore_data: restore_data} = state) do
    {:reply, restore_data, state}
  end

  def handle_call(:verified?, _, %{verified: verified} = state) do
    {:reply, verified, state}
  end

  def handle_call(:alive?, _, state) do
    {:reply, true, state}
  end

  def handle_call(:debug, _, state) do
    {:reply, state, state}
  end
end
