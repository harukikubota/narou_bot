defmodule NarouBot.Command.Invoker do

  def invoke(mod, func_name, param),          do: _invoke(env(), mod, func_name, param)
  defp _invoke(:test, mod, func_name, param), do: [mod, func_name, param]
  defp _invoke(_, mod, func_name, param) do
    {:ok, pid} = apply(mod, :init, [])

    apply(mod, func_name, [param])

    apply(mod, :close, [pid])
  end
  defp env(), do: Mix.env
end
