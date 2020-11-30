defmodule NarouBot.Command do
  defmacro __using__(_) do
    quote do
      alias NarouBot.Command.MessageServer, as: MS
      alias NarouBot.Command.Helper

      def init(reply_token),   do: MS.start_link(key(),reply_token)
      def setup(param),        do: param
      def callable?(_param),   do: true
      def call(_param),        do: IO.inspect "override this." # do something
      def close(),             do: MS.stop(key())

      defoverridable setup: 1, callable?: 1, call: 1

      defp export(vars),        do: Enum.each(vars, fn {k, v} -> MS.push_val(key(), k, v) end)
      defp render(id),          do: MS.push_message(key(), template().render(id, MS.get_dao(key())))
      defp send_message(),      do: LineBot.send_reply(reply_token(), messages())
      defp render_with_send(id) do
        render(id)
        send_message()
      end

      defp template(),          do: NarouBot.Command.template_name(__MODULE__)
      defp messages(),          do: MS.get_messages(key())
      defp reply_token(),       do: MS.get_reply_token(key())
      defp key(),               do: self()
    end
  end

  def template_name(module) do
    module
    |> to_string
    |> String.split(".")
    |> List.replace_at(2, "Template")
    |> Enum.join(".")
    |> String.to_atom
  end
end
