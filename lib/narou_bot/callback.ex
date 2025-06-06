defmodule NarouBot.Callback do
  use LineBot

  alias NarouBot.Util.Constant

  @invoker NarouBot.Command.Invoker

  def handle_message(%{type: "text", text: ":" <> opt}, info) do
    case opt do
      "h"  -> invoke([:admin, :help], info)
      "i"  -> invoke([:admin, :info], info)
      "d"  -> invoke([:admin, :dump], info)
      "r"  -> invoke([:admin, :rest], info)
      "rs" -> invoke([:admin, :rest_start], info)
      _    -> default(info)
    end
  end

  def handle_message(%{type: "text", text: message}, info) do
    with %{"ncode" => ncode, "episode_id" => episode_id} <- Regex.named_captures(Constant.novel_regex(), message)
    do
      invoke([:novel, :receive_novel_url], Map.merge(info, %{ncode: ncode, episode_id: episode_id}))
    else
      _ ->
        with %{"writer_id" => writer_id}
          <- Regex.named_captures(Constant.writer_regex(), message)
        do
          invoke([:writer, :receive_writer_url], Map.merge(info, %{writer_id: String.to_integer(writer_id)}))
        else
          _ -> default(info)
        end
    end
  end

  def handle_follow(info),   do: invoke([:user, :follow],   info)
  def handle_unfollow(info), do: invoke([:user, :unfollow], info)

  def handle_postback(data, info) do
    {%{action: action}, data} = data |> Map.split([:action])

    action
    |> String.split("/")
    |> Enum.map(&String.to_atom/1)
    |> invoke(Map.merge(info, %{data: data}))
  end

  defp default(info), do: invoke(:default, info)

  @spec invoke(any, map) :: {:ok, any} | {:error, any}
  defp invoke(mod_symbols, param) do
    to_mod(mod_symbols) |> @invoker.invoke(param)
  end

  defp to_mod(mod_symbols) do
    List.wrap(mod_symbols)
    |> Enum.map(&Macro.camelize(to_string(&1)))
    |> Enum.join(".")
    |> then(&Module.concat(NarouBot.Command, &1))
  end
end
