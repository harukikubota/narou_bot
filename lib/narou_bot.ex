defmodule NarouBot do
  @moduledoc """
  NarouBot keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  def command do
    quote do
      import NarouBot.Command.Helper
    end
  end

  @doc """
  When used, dispatch to the appropriate command/template/etc.
  """
  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
