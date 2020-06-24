defmodule NarouBot.Command do
  defmacro __using__(_) do
    quote do
      alias LineBot.Message
      alias NarouBot.Command.MessageServer, as: MS
      alias NarouBot.Command.Helper

      def init(reply_token),    do: MS.start_link(self(),reply_token)
      def template(),           do: NarouBot.Command.template_name(__MODULE__)
      def messages(),        do: MS.get_messages(self())
      def reply_token(),     do: MS.get_reply_token(self())
      def render(id), do: template().render(id, MS.get_dao(self())) |> MS.push_message(self())
      def send(),            do: LineBot.send_reply(reply_token(), messages())
      def render_with_send(id) do
        render(id)
        send()
      end
      def close(), do: MS.stop(self())
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
