defmodule NarouBot.Command.Invoker do
  require Logger

  def invoke(mod, param),          do: _invoke(Mix.env, mod, param)
  defp _invoke(:test, mod, param), do: [mod, param]
  defp _invoke(_, mod, param) do
    Logger.info "invoked Module: #{inspect(mod)}"

    apply(mod, :init, [param.reply_token])

    param = Map.merge(param, apply(mod, :setup, [param]))

    if apply(mod, :callable?, [param]) do
      apply(mod, :call, [param])
    else
      Logger.debug "Command is not callable."
    end

    apply(mod, :close, [])
  end
end
