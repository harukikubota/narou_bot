defmodule NarouBot.Command do
  defmacro __using__(_) do
    quote do
      alias LineBot.Message
      alias NarouBot.Command.MessageServer, as: MS
      alias NarouBot.Command.Helper

      def init(token),          do: {:ok, pid} = MS.start_link(token)
      def template(),           do: NarouBot.Command.template_name(__MODULE__)
      def messages(pid),        do: MS.get_messages(pid)
      def reply_token(pid),     do: MS.get_reply_token(pid)
      def render(id, dao, pid), do: template().render(id, dao) |> MS.push(pid)
      def send(pid),            do: LineBot.send_reply(reply_token(pid), messages(pid))
      def render_with_send(id, dao, pid) do
        render(id, dao, pid)
        send(pid)
      end
      def close(pid), do: MS.stop(pid)
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
